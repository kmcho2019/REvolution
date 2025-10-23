module TopModule(
    input  [7:0] in,
    output [31:0] out
);
    // Directly assign the sign-extended value to out
    assign out = {24{in[7]}, in};
endmodule