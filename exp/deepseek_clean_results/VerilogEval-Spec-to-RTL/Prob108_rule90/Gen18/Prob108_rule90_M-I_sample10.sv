module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

parameter WIDTH = 512;

// Next state computation
wire [WIDTH-1:0] next_q;

// Boundary-aware neighbor selection with optimized implementation
assign next_q[0] = 1'b0 ^ q[1];  // Left boundary is 0
assign next_q[WIDTH-1] = q[WIDTH-2] ^ 1'b0;  // Right boundary is 0

genvar i;
generate
    for (i = 1; i < WIDTH-1; i = i + 1) begin: rule90
        assign next_q[i] = q[i-1] ^ q[i+1];
    end
endgenerate

// State update with load functionality
always @(posedge clk) begin
    q <= load ? data : next_q;
end

endmodule