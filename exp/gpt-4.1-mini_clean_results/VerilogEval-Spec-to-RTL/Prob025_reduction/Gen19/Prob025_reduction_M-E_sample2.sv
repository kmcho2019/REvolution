module TopModule (
    input  [7:0] in,
    output       parity
);
    wire x1, x2, x3, x4; // stage 1 outputs: 4 XORs of input pairs
    wire y1, y2;         // stage 2 outputs: 2 XORs of previous outputs

    // Stage 1: XOR input pairs
    assign x1 = in[0] ^ in[1];
    assign x2 = in[2] ^ in[3];
    assign x3 = in[4] ^ in[5];
    assign x4 = in[6] ^ in[7];

    // Stage 2: XOR stage 1 outputs
    assign y1 = x1 ^ x2;
    assign y2 = x3 ^ x4;

    // Final parity bit: XOR stage 2 outputs
    assign parity = y1 ^ y2;
endmodule