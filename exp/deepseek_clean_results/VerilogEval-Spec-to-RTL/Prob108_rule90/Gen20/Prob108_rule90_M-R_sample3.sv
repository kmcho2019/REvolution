module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

// Next state computation (combinational logic)
wire [511:0] next_q;

// Rule 90 implementation with boundary conditions
assign next_q[0] = 1'b0 ^ q[1];  // Left neighbor is 0
assign next_q[511] = q[510] ^ 1'b0;  // Right neighbor is 0

// Middle cells
genvar i;
generate
    for (i = 1; i < 511; i = i + 1) begin: middle_cells
        assign next_q[i] = q[i-1] ^ q[i+1];
    end
endgenerate

// State update (sequential logic)
always @(posedge clk) begin
    q <= load ? data : next_q;
end

endmodule