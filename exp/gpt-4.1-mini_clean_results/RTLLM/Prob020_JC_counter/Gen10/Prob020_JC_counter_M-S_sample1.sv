module JC_counter (
    input  wire       clk,
    input  wire       rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) 
    Q <= rst_n ? {~Q[0], Q[63:1]} : 64'b0;

endmodule