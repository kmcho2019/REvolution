module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[0];
wire [4:0] next_q = {feedback, q[4], q[3] ^ feedback, q[2], q[1]};
wire clk_enable = ~reset & (next_q != q);  // Clock gating when no state change

always @(posedge clk) begin
    if (reset) q <= 1;
    else if (clk_enable) q <= next_q;
end

endmodule