module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Tap mask for positions 31, 21, 1, 0 (equivalent to 32,22,2,1 in 1-based)
localparam [31:0] TAP_MASK = 32'h8000_0002 | 32'h0020_0000 | 32'h0000_0003;

wire [31:0] xor_mask = {32{q[0]}} & TAP_MASK;
wire [31:0] next_q = reset ? 32'h1 : ((q >> 1) ^ xor_mask);

always @(posedge clk) begin
    q <= next_q;
end

endmodule