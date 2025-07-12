module TopModule (
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Intermediate calculations
    wire and_temp = in[0] & in[1] & in[2] & in[3];
    wire or_temp  = in[0] | in[1] | in[2] | in[3];
    wire xor_temp = in[0] ^ in[1] ^ in[2] ^ in[3];

    // Output assignments
    assign out_and = and_temp;
    assign out_or  = or_temp;
    assign out_xor = xor_temp;

endmodule