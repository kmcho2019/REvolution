module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

wire [63:0] next_Q;

assign next_Q = {~Q[0], Q[63:1]};

always @(posedge clk or negedge rst_n)
    if (!rst_n) Q <= 0;
    else Q <= next_Q;

endmodule