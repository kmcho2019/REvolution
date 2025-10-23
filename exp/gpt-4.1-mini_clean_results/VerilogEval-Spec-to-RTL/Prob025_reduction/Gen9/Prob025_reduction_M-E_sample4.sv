module TopModule (
    input  [7:0] in,
    output       parity
);
    // Internal signals to hold intermediate XOR results at each tree level
    wire [3:0] level1;
    wire [1:0] level2;
    wire       level3;

    // Level 1: XOR pairs of input bits
    assign level1[0] = in[0] ^ in[1];
    assign level1[1] = in[2] ^ in[3];
    assign level1[2] = in[4] ^ in[5];
    assign level1[3] = in[6] ^ in[7];

    // Level 2: XOR pairs of level 1 results
    assign level2[0] = level1[0] ^ level1[1];
    assign level2[1] = level1[2] ^ level1[3];

    // Level 3: XOR the two level 2 results to get final parity
    assign level3 = level2[0] ^ level2[1];

    // Output parity bit representing even parity of the input
    assign parity = level3;
endmodule