module TopModule (
    input  [7:0] in,
    output       parity
);
    localparam WIDTH = 8;

    // Intermediate hierarchical XOR signals to illustrate parity calculation structure
    wire xor01 = in[0] ^ in[1];
    wire xor23 = in[2] ^ in[3];
    wire xor45 = in[4] ^ in[5];
    wire xor67 = in[6] ^ in[7];

    wire xor0123 = xor01 ^ xor23;
    wire xor4567 = xor45 ^ xor67;

    // Final parity output computed using the reduction XOR operator for optimized synthesis
    assign parity = ^in;

    // The intermediate wires can serve as documentation or debug signals
    // but do not affect final parity computation, ensuring optimal logic.
endmodule