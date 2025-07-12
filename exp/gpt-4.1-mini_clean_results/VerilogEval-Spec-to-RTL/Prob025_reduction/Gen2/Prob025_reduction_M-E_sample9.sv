module TopModule (
    input  [7:0] in,
    output parity
);
    wire p0, p1, p2, p3;
    wire q0, q1;
    
    // XOR pairs
    assign p0 = in[0] ^ in[1];
    assign p1 = in[2] ^ in[3];
    assign p2 = in[4] ^ in[5];
    assign p3 = in[6] ^ in[7];

    // XOR the results of pairs
    assign q0 = p0 ^ p1;
    assign q1 = p2 ^ p3;

    // Final parity is XOR of last two partial parities
    assign parity = q0 ^ q1;

endmodule