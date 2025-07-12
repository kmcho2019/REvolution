module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

parameter WIDTH = 512;
parameter CHUNK_SIZE = 32;  // Reduced chunk size for better timing

// Boundary conditions
wire left_boundary = 1'b0;
wire right_boundary = 1'b0;

// Next state computation
wire [WIDTH-1:0] next_q;

genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin: rule90
        // Efficient boundary-aware neighbor selection
        wire left = (i == 0) ? left_boundary : q[i-1];
        wire right = (i == WIDTH-1) ? right_boundary : q[i+1];
        
        // Hierarchical XOR implementation
        assign next_q[i] = left ^ right;
    end
endgenerate

// Optimized clock gating - only when load or state changes
wire clk_en = load || (next_q != q);

// State update with load functionality
always @(posedge clk) begin
    if (clk_en) begin
        q <= load ? data : next_q;
    end
end

endmodule