module TopModule(
    input  [7:0] in,
    output [7:0] out
);

reg [7:0] shift_reg;

always @(in) begin
    shift_reg[0] <= in[7];
    shift_reg[1] <= in[6];
    shift_reg[2] <= in[5];
    shift_reg[3] <= in[4];
    shift_reg[4] <= in[3];
    shift_reg[5] <= in[2];
    shift_reg[6] <= in[1];
    shift_reg[7] <= in[0];
end

assign out = shift_reg;

endmodule