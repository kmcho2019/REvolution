module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

parameter WIDTH = 512;
wire [WIDTH-1:0] next_q;

// Rule 90 implementation with explicit boundary handling
assign next_q[0] = 1'b0 ^ q[1];       // Left neighbor is 0
assign next_q[WIDTH-1] = q[WIDTH-2] ^ 1'b0;  // Right neighbor is 0

// Middle cells
genvar i;
generate
    for (i = 1; i < WIDTH-1; i = i + 1) begin: rule90
        assign next_q[i] = q[i-1] ^ q[i+1];
    end
endgenerate

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule