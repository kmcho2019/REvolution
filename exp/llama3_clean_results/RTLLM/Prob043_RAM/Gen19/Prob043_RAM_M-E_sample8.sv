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

// Define two separate arrays for writing and reading
reg [5:0] write_array [7:0];
reg [5:0] read_array [7:0];

// Flag to indicate when the read array needs to be updated
reg update_read_array;

// Simplified clock gating for power optimization
reg clk_gated;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_gated <= 1'b0;
    end else begin
        clk_gated <= write_en | read_en;
    end
end

// Sequential block for write operation and reset
always @(posedge clk_gated or negedge rst_n) begin
    if (!rst_n) begin
        // Optimized reset logic
        for (int i = 0; i < DEPTH; i++) begin
            write_array[i] <= 6'b0;
            read_array[i] <= 6'b0;
        end
        update_read_array <= 1'b0;
    end else if (write_en) begin
        write_array[write_addr] <= write_data;
        update_read_array <= 1'b1;
    end
end

// Update read array when new data is written
always @(posedge clk_gated) begin
    if (update_read_array) begin
        for (int i = 0; i < DEPTH; i++) begin
            read_array[i] <= write_array[i];
        end
        update_read_array <= 1'b0;
    end
end

// Combinatorial logic for read operation
assign read_data = (read_en)? read_array[read_addr] : 6'b0;

endmodule