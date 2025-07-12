module TopModule(
    input  [7:0] in,
    output [31:0] out
);

    wire [23:0] sign_ext_bits;
    assign sign_ext_bits = {24{in[7]}};
    assign out = {sign_ext_bits, in};

endmodule