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

reg [WIDTH-1:0] RAM [DEPTH-1:0];

// Separate always block for reset logic
always @(negedge rst_n) begin
    // Optimized reset logic
    for (int i = 0; i < DEPTH; i++) begin
        RAM[i] <= {WIDTH{1'b0}};
    end
end

// Single always block for write operation
always @(posedge clk) begin
    if (rst_n && write_en) begin
        RAM[write_addr] <= write_data;
    end
end

// Combinatorial logic for read operation
assign read_data = (read_en)? RAM[read_addr] : {WIDTH{1'b0}};

endmodule