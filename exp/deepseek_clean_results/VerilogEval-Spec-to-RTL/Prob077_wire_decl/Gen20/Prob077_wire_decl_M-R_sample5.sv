module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    // Parameterized LUT for (a&b)|(c&d)
    wire [3:0] input_vector = {a, b, c, d};
    wire lut_out = (input_vector == 4'b0011 ||  // c&d
                   input_vector == 4'b0111 ||  // c&d
                   input_vector == 4'b1011 ||  // c&d
                   input_vector == 4'b1100 ||  // a&b
                   input_vector == 4'b1101 ||  // a&b
                   input_vector == 4'b1110 ||  // a&b
                   input_vector == 4'b1111);  // a&b & c&d

    assign out = lut_out;
    assign out_n = ~lut_out;
endmodule