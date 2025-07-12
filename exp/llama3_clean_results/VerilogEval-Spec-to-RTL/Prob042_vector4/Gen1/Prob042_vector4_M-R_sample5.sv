module TopModule(
    input  [7:0] in,
    output [31:0] out
);

reg [31:0] out_reg;

always @(*)
begin
    reg [23:0] sign_bit_extension;
    sign_bit_extension = {24{in[7]}};
    out_reg = {sign_bit_extension, in};
end

assign out = out_reg;

endmodule