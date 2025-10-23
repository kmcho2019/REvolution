module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

parameter WIDTH = 512;

// Boundary conditions (optimized implementation)
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
        
        // Core Rule 90 logic - hierarchical XOR implementation
        assign next_q[i] = left ^ right;
    end
endgenerate

// State update with load functionality
// Simplified - always update on clock edge (no conditional clock gating)
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule