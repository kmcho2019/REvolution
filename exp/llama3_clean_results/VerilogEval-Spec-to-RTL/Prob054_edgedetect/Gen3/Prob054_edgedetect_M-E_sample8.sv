module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] shift_reg;  // shift register to store the previous state of the input signal

always @(posedge clk) begin
    shift_reg <= in;  // shift the input into the register
    pedge <= in & ~shift_reg;  // detect 0 to 1 transition
end

initial begin
    shift_reg = 8'b0;  // initialize the shift register
    pedge = 8'b0;  // initialize the output
end

endmodule