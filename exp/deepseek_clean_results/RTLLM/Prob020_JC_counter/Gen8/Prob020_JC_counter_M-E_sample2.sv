module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

wire [63:0] next_Q_inc = {1'b1, Q[63:1]};  // Increment path
wire [63:0] next_Q_dec = {1'b0, Q[63:1]};  // Decrement path
wire [63:0] next_Q = Q[0] ? next_Q_dec : next_Q_inc;

always @(posedge clk or negedge rst_n)
    if (!rst_n) Q <= 64'b0;
    else Q <= next_Q;

endmodule