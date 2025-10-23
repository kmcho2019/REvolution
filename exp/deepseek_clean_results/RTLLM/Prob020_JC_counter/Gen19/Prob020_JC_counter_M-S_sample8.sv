module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk) Q <= !rst_n ? 0 : {~Q[0], Q[63:1]};

endmodule