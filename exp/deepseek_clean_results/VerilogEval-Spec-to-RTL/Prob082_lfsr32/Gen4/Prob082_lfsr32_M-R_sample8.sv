module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

parameter TAP_MASK = 32'h80040003;  // Taps at bits 31,21,1,0 (32,22,2,1 in 1-based)
wire feedback = q[0];
wire [31:0] next_q = {1'b0, q[31:1]} ^ ({32{feedback}} & TAP_MASK);

always @(posedge clk) begin
    q <= reset ? 32'h1 : next_q;
end

endmodule