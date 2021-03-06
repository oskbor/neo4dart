part of neo4dart;

/**
 * The starting point for REST api as a singleton (can be called everywhere)
 */
class Neo4Dart {
  
  static Neo4Dart _instance;

  Map _context;
  String _baseUrl;
  
  Nodes _nodes;
  RelationShipTypes _relationTypes;
  Version _version;
  
  /// Get the Neo4J version
  Version get version => _version;
  /// Get a [Nodes] service instance to request about nodes
  Nodes get nodes => _nodes;
  /// Get a [RelationShipTypes] service instance to request about relationship types
  RelationShipTypes get relationTypes => _relationTypes;

  /**
   * Factory constructor which returns the singleton instance
   */
  factory Neo4Dart() => _instance;
  
  /*
   * Internal constructor (private)
   */
  Neo4Dart._fromJSON(this._baseUrl, Map context) {
    _context = context;
    _nodes = new Nodes(context['node']);
    _relationTypes = new RelationShipTypes(context['relationship_types']);
    _version = new ServiceFactory().get(ServiceFactory.VERSION, _context);
  }
  
  /**
   * Returns the [Neo4Dart] instance
   */
  static Neo4Dart get() => _instance;
  
  /**
   * Initialize the connection with the server. Under the hood it request the service root to get hyper media links so
   * use the [client] getter only when this method has returned 
   */
  static Future<Neo4Dart> init(String host, {String scheme : 'http', int port: 7474}) {
    Completer completer = new Completer();
    String baseUrl = "http://${host}:${port}/db/data";
    _send(baseUrl).then((result) {
       _instance = new Neo4Dart._fromJSON(baseUrl, result); 
      completer.complete(_instance);
    });
    return completer.future;
  }
}


