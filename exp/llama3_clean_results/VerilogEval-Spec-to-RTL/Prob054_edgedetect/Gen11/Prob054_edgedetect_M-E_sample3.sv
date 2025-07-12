module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] stage1_reg;  // register to store the current input value
reg [7:0] stage2_reg;  // register to store the output of the comparator

always @(posedge clk) begin
    stage1_reg <= in;  // capture the current input value
    stage2_reg <= stage1_reg & ~in;  // detect 0 to 1 transition using comparator
    pedge <= stage2_reg;  // output the result
end

endmodule