module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Internal wires for the multiplexer outputs
    wire m1_out, m2_out;

    // First level of multiplexing based on 'a' and 'b'
    // The output of each multiplexer is determined based on the Karnaugh map
    // For 'ab = 00', the output is determined by 'c' and 'd'
    // For 'ab = 01', the output is determined by the inverse of 'c' and 'd'
    // For 'ab = 10', the output is determined by the inverse of 'c' XOR 'd'
    // For 'ab = 11', the output is determined by 'c' XOR 'd'

    assign m1_out = (a == 0 && b == 0) ? (c ^ d) : 
                    (a == 0 && b == 1) ? ~(c ^ d) : 
                    (a == 1 && b == 0) ? ~(c ^ d) : 
                    (a == 1 && b == 1) ? (c ^ d) : 0;

    assign m2_out = (a == 0 && b == 0) ? (c ^ d) : 
                    (a == 0 && b == 1) ? (c ^ d) : 
                    (a == 1 && b == 0) ? ~(c ^ d) : 
                    (a == 1 && b == 1) ? ~(c ^ d) : 0;

    // Final output selection based on 'c' and 'd'
    assign out = (c == 0 && d == 0) ? m1_out : 
                 (c == 0 && d == 1) ? m2_out : 
                 (c == 1 && d == 0) ? m2_out : 
                 (c == 1 && d == 1) ? m1_out : 0;

endmodule