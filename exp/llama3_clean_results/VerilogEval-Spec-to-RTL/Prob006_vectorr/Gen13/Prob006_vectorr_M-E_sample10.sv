module TopModule(
    input  [7:0] in,
    output [7:0] out
);

reg [7:0] shift_reg;

always @(*) begin
    shift_reg = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};
    out = {shift_reg[7], shift_reg[6], shift_reg[5], shift_reg[4], shift_reg[3], shift_reg[2], shift_reg[1], shift_reg[0]};
end

endmodule