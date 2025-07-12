module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output [5:0] read_data
);

parameter WIDTH = 6;
parameter DEPTH = 8;

// Hybrid memory structure: Register-based section for frequent access
reg [5:0] reg_section [3:0];

// Dedicated memory block section for less frequent access
reg [5:0] mem_block [7:0];

// Cache for recently accessed data
reg [5:0] cache [1:0];
reg [1:0] cache_tag;

// Asynchronous read and write control signals
reg read_req, write_req;
reg read_ack, write_ack;

// Handshaking logic for asynchronous operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_req <= 1'b0;
        write_req <= 1'b0;
        read_ack <= 1'b0;
        write_ack <= 1'b0;
    end else begin
        if (read_en) begin
            read_req <= 1'b1;
        end
        if (write_en) begin
            write_req <= 1'b1;
        end
        if (read_req && !read_ack) begin
            // Read operation
            if (read_addr < 4) begin
                // Access register-based section
                read_data <= reg_section[read_addr];
            end else begin
                // Access dedicated memory block section
                read_data <= mem_block[read_addr];
            end
            read_ack <= 1'b1;
        end
        if (write_req && !write_ack) begin
            // Write operation
            if (write_addr < 4) begin
                // Write to register-based section
                reg_section[write_addr] <= write_data;
            end else begin
                // Write to dedicated memory block section
                mem_block[write_addr] <= write_data;
            end
            write_ack <= 1'b1;
        end
        if (read_ack) begin
            read_req <= 1'b0;
            read_ack <= 1'b0;
        end
        if (write_ack) begin
            write_req <= 1'b0;
            write_ack <= 1'b0;
        end
    end
end

// Cache management
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cache_tag <= 2'b0;
    end else begin
        if (read_req) begin
            // Check if requested data is in cache
            if (cache_tag == read_addr[1:0]) begin
                read_data <= cache[read_addr[0]];
            end else begin
                // Update cache with newly accessed data
                cache[read_addr[0]] <= (read_addr < 4) ? reg_section[read_addr] : mem_block[read_addr];
                cache_tag <= read_addr[1:0];
            end
        end
    end
end

endmodule