from itertools import chain

from scipy.spatial import distance


def linear_depth(static_cost_weight, depth_cost_weight):
    """
    Constructs function for linear depth cost
    :param static_cost_weight: cost experienced for all nodes
    :param depth_cost_weight: amount of additional cost per depth level,
                              with no depth cost experienced at first level
    :return: function given these two parameters
    """

    # construct function, avoiding lambda for kwarg
    def cost_function(node, last_action=None, graph=None):
        depth = graph.nodes[node]["depth"]
        # if depth is 0 it is initial node so we return 0
        return -(1 * static_cost_weight + depth * depth_cost_weight) if depth > 0 else 0

    return cost_function


def side_cost(given_cost, side_preferences):
    """
    Constructs function for cost which redistributes base cost
                            according to side preferences
    :param given_cost: instructed cost to participants
                            (e.g. lose -1 for every inspection)
    :param side_preferences: dictionary of relative preferences for each side
                             (e.g. {"right": 1/3, "left": 1/3, "up" :1/3})
    :return: function which redistributes cost according to these parameters
    """
    if abs(1.0 - sum(side_preferences.values())) > 0.001:
        raise ValueError("Side preferences array must sum to 1")

    # construct function, avoiding lambda for kwarg
    def cost_function(node, last_action=None, graph=None):
        equitable_distribution = 1 / len(side_preferences)
        adjusted_side_preferences = {
            cluster: pref / equitable_distribution * given_cost
            for cluster, pref in side_preferences.items()
        }
        return -(adjusted_side_preferences[graph.nodes[node]["cluster"]])

    return cost_function


def distance_graph_cost(
    given_cost=1,
    distance_function=distance.euclidean,
    max_penalty=None,
    distance_multiplier=1.2,
):
    """
    Constructs function for reducing cost for closer nodes
    :param given_cost: instructed cost to participants
                                            (e.g. lose -1 for every inspection)
    :param distance_function: takes in two points as lists
                                            and outputs a scalar distance between them
    :param max_penalty: maximum penalty
    :param distance_multiplier: amount to multiply distances by
    :return: function which adjusts cost so that nodes closer to the
                                            last click are shorter
    """

    # construct function, avoiding lambda for kwarg
    def cost_function(node, last_action=None, graph=None):
        """
        :param node: node that is clicked on
        :param last_action: action before this (can be non-revealing action if recorded)
        """

        distance = distance_function(
            graph.nodes[node]["layout"], graph.nodes[last_action]["layout"]
        )
        if max_penalty is None:
            return -(given_cost * 1 + distance_multiplier * distance)
        else:
            return -min((given_cost + distance_multiplier * distance), max_penalty)

    return cost_function


def backward_search_cost(added_cost=1, inspection_cost=1, include_start=False):
    """
    Constructs function for reducing cost for nodes downstream of inspected nodes
    :param added_cost: cost to add if parent node not inspected
    :param inspection_cost: baseline cost to inspect
    :param include_start: whether to count start as 'inspected' node or not
    :return: function which adjusts cost so that nodes which are children
                                    of already inspected nodes are favored
    """

    if not isinstance(include_start, bool):
        include_start = bool(include_start)

    # construct function, avoiding lambda for kwarg
    def cost_function(node, last_action=None, graph=None):
        """
        :param node: node that is clicked on
        :param last_action: action before this (can be non-revealing action if recorded)
        """

        revealed_nodes = [
            node for node, info in graph.nodes(data=True) if info["revealed"]
        ]

        if not include_start:
            revealed_nodes.remove(0)

        predecessors = chain(*(graph.predecessors(state) for state in revealed_nodes))

        if node in predecessors:
            return -(inspection_cost + added_cost)
        else:
            return -(inspection_cost)

    return cost_function


def forward_search_cost(added_cost=1, inspection_cost=1, include_start=False):
    """
    Constructs function for reducing cost for nodes upstream of inspected nodes
    :param added_cost: cost to add if parent node not inspected
    :param inspection_cost: baseline cost to inspect
    :param include_start: whether to count start as 'inspected' node or not
    :return: function which adjusts cost so that nodes which are parents
                                    of already inspected nodes are favored
    """

    if not isinstance(include_start, bool):
        include_start = bool(include_start)

    # construct function, avoiding lambda for kwarg
    def cost_function(node, last_action=None, graph=None):
        """
        :param node: node that is clicked on
        :param last_action: action before this (can be non-revealing action if recorded)
        """
        revealed_nodes = [
            node for node, info in graph.nodes(data=True) if info["revealed"]
        ]

        if not include_start:
            revealed_nodes.remove(0)

        successors = chain(*(graph.successors(state) for state in revealed_nodes))

        if node in successors:
            return -(inspection_cost + added_cost)
        else:
            return -(inspection_cost)

    return cost_function


def neighbor_search_cost(added_cost=1, inspection_cost=1, include_start=False):
    """
    Constructs function for reducing cost for nodes adjacent to inspected nodes
    :param added_cost: cost to add if parent node not inspected
    :param inspection_cost: baseline cost to inspect
    :param include_start: whether to count start as 'inspected' node or not
    :return: function which adjusts cost so that nodes which are parents
                                    of already inspected nodes are favored
    """

    if not isinstance(include_start, bool):
        include_start = bool(include_start)

    # construct function, avoiding lambda for kwarg
    def cost_function(node, last_action=None, graph=None):
        """
        :param node: node that is clicked on
        :param last_action: action before this (can be non-revealing action if recorded)
        """
        revealed_nodes = [
            node for node, info in graph.nodes(data=True) if info["revealed"]
        ]

        if not include_start:
            revealed_nodes.remove(0)

        neighbors = chain(*(graph.neighbors(state) for state in revealed_nodes))

        if node in neighbors:
            return -(inspection_cost + added_cost)
        else:
            return -(inspection_cost)

    return cost_function
