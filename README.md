# LFU Multithreaded Proxy Server

This project is a **Multithreaded Proxy Server** implemented in C++, capable of handling multiple client requests concurrently using threads. The proxy server utilizes an **LFU (Least Frequently Used) caching strategy** to store responses to frequently requested URLs, optimizing response times and reducing load on remote servers. It includes functionality for connecting to remote servers, parsing HTTP requests, sending appropriate error responses, and managing cache size with thread-safe mechanisms.

---

## Features

1. **Multithreaded Request Handling**: Capable of handling up to `MAX_CLIENTS` simultaneous connections using POSIX threads, each request served by a separate thread.
2. **LFU Caching**: Stores HTTP responses in cache elements with **Least Frequently Used** caching strategy, allowing faster responses for frequently requested resources.
3. **HTTP Error Handling**: Custom error handling for common HTTP errors (e.g., `400 Bad Request`, `404 Not Found`).
4. **Thread-Safe Cache Management**: Uses semaphores and mutexes for thread-safe operations on cache elements.
5. **Dynamic Cache Size Management**: The cache dynamically manages its size up to a defined `MAX_SIZE`, and the `MAX_ELEMENT_SIZE` sets the limit for the largest cacheable object.

---

## Dependencies

- **Linux** or UNIX-based OS (for `POSIX` thread and socket functions)
- **gcc/g++** compiler

---

## File Structure

- `proxy_parse.h`: Header file containing necessary definitions for parsing HTTP requests.
- `proxy.cpp`: Main source file for the proxy server, which includes the LFU caching, threading, and socket handling functions.
- `Makefile`: Build file for compiling and running the proxy server.

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/proxy-server.git
   cd proxy-server
   ```

2. Compile the source code:
   ```bash
   make
   ```

---

## Usage

1. **Run the Proxy Server**:
   ```bash
   ./proxy <port_number>
   ```
   By default, the server listens on port `8080`.

2. **Send Requests through the Proxy**:
   Configure a web browser or an HTTP client (like `curl`) to use `localhost:<port_number>` as the proxy server. For example:
   ```bash
   curl -x http://localhost:8080 http://example.com
   ```

---

## Configuration Parameters

1. **`MAX_CLIENTS`**: Maximum number of simultaneous clients. Default is 400.
2. **`MAX_BYTES`**: Maximum size of each client request/response in bytes. Default is 4096.
3. **`MAX_SIZE`**: Total cache size in bytes. Default is 2048.
4. **`MAX_ELEMENT_SIZE`**: Maximum size of a single cached element. Default is `10 * (1 << 20)`.

To modify these parameters, change their values in the source code and recompile.

---

## Code Overview

### LFU Caching Mechanism

- Each cached element is represented by a `cache_element` structure containing:
  - `data`: The cached response data.
  - `url`: The request URL.
  - `frequency`: Access frequency count.
  - `last_accessed`: Timestamp for tie-breaking in LFU decisions.
  - `next`: Pointer to the next cache element (for linked list structure).

- **Cache Lookup (`find`)**: Checks if a requested URL is in the cache.
- **Cache Insertion (`add_cache_element`)**: Adds a new element to the cache. If the cache is full, the LFU eviction policy removes the least frequently accessed item.
- **Cache Removal (`remove_cache_element`)**: Removes a specific cache element to maintain the cache size limit.

### Error Handling

The `sendErrorMessage` function returns appropriate HTTP error responses for client requests that encounter issues, like `400 Bad Request`, `403 Forbidden`, `404 Not Found`, and more.

### Thread Management

- **Semaphore** (`seamaphore`) to manage the maximum number of active client threads.
- **Mutex Lock** (`lock`) to protect access to the shared cache.
- Each client request is handled by the `thread_fn` function, which:
  - Parses and processes the client request.
  - Checks the cache for the requested resource.
  - If the resource is cached, serves it directly; otherwise, fetches it from the remote server.

---

## Example Workflow

1. A client connects to the proxy server and sends an HTTP request.
2. The proxy server checks the cache:
   - If found, the response is served directly from the cache.
   - If not found, the proxy connects to the target server, fetches the response, and caches it if it fits within the cache size limit.
3. The proxy returns the response to the client.

---

## Limitations

- **HTTP/1.1 Only**: This server supports only HTTP/1.1 and HTTP/1.0 requests.
- **Cache Capacity**: Cache may not fit very large responses due to `MAX_ELEMENT_SIZE` limits.

---

## Contributing

Contributions are welcome! Please submit pull requests with a description of the changes. 

---

## License

This project is open-source, licensed under the MIT License.

