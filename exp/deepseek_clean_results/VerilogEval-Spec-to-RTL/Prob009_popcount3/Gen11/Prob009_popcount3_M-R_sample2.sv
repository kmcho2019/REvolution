module TopModule (
    input [2:0] in,
    output [1:0] out
);
    // Intermediate pairwise AND signals
    wire and01 = in[0] & in[1];
    wire and12 = in[1] & in[2];
    wire and02 = in[0] & in[2];

    // Population count outputs
    assign out[1] = and01 | and12 | and02;  // Majority function (2 or more 1's)
    assign out[0] = in[0] ^ in[1] ^ in[2];  // XOR parity (odd number of 1's)
endmodule