module TopModule (
    input  [7:0] in,
    output       parity
);
    // Step 1: Compute XOR of every 2-bit group
    wire [3:0] xor_2bit;
    assign xor_2bit[0] = in[0] ^ in[1];
    assign xor_2bit[1] = in[2] ^ in[3];
    assign xor_2bit[2] = in[4] ^ in[5];
    assign xor_2bit[3] = in[6] ^ in[7];

    // Step 2: XOR pairs of previous results
    wire [1:0] xor_4bit;
    assign xor_4bit[0] = xor_2bit[0] ^ xor_2bit[1];
    assign xor_4bit[1] = xor_2bit[2] ^ xor_2bit[3];

    // Step 3: Final XOR to produce even parity
    assign parity = xor_4bit[0] ^ xor_4bit[1];
endmodule