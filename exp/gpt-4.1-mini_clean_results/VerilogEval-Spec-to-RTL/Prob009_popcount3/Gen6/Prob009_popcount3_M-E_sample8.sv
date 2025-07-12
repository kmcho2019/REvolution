module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    wire bit0_xor;
    wire bit1_majority;

    // XOR of all three bits (parity bit)
    assign bit0_xor = in[0] ^ in[1] ^ in[2];

    // Majority function: true if at least two inputs are 1
    assign bit1_majority = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);

    assign out = {bit1_majority, bit0_xor};

endmodule