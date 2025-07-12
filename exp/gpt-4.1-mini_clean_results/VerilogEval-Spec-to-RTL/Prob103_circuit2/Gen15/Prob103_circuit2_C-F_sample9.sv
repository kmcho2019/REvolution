module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // The output 'q' implements a 4-input even parity function.
    // 'q' is high if the number of '1's among inputs a,b,c,d is even.
    // This matches the provided truth table where 'q' corresponds to inverted XOR of inputs.
    //
    // The truth table (LUT) from the waveform:
    // {a,b,c,d} : q
    // 0000 : 1, 0001 : 0, 0010 : 0, 0011 : 1,
    // 0100 : 0, 0101 : 1, 0110 : 1, 0111 : 0,
    // 1000 : 0, 1001 : 1, 1010 : 1, 1011 : 0,
    // 1100 : 1, 1101 : 0, 1110 : 0, 1111 : 1

    // This is equivalently expressed as the inversion of the reduction XOR of all inputs.
    assign q = ~(^ {a, b, c, d});

endmodule