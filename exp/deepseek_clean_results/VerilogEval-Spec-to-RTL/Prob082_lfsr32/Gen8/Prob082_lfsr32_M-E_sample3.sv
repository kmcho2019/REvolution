module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Tap mask - bits set at positions 32, 22, 2, and 1 (note: bit 32 is q[31] in 0-based)
localparam [31:0] TAP_MASK = 32'h8000_0403;

wire [31:0] next_q;

// Parallel XOR network: each bit either shifts or XORs with q[0]
assign next_q = {q[30:0], 1'b0} ^ ({32{q[0]}} & TAP_MASK);

always @(posedge clk) begin
    q <= reset ? 32'h1 : next_q;
end

endmodule