module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Internal wires for shifted and aligned bits
    wire [3:0] in_shifted_left;
    wire [3:0] in_shifted_right;
    wire [3:0] in_aligned_different;

    // Shift and align bits
    assign in_shifted_left[0] = in[3];
    assign in_shifted_left[1] = in[0];
    assign in_shifted_left[2] = in[1];
    assign in_shifted_left[3] = in[2];

    assign in_shifted_right[0] = in[1];
    assign in_shifted_right[1] = in[2];
    assign in_shifted_right[2] = in[3];
    assign in_shifted_right[3] = in[0];

    assign in_aligned_different[0] = in[3];
    assign in_aligned_different[1] = in[0];
    assign in_aligned_different[2] = in[1];
    assign in_aligned_different[3] = in[2];

    // Perform operations
    assign out_both[0] = in[0] & in_shifted_left[0];
    assign out_both[1] = in[1] & in_shifted_left[1];
    assign out_both[2] = in[2] & in_shifted_left[2];
    assign out_both[3] = 1'b0; // No left neighbour for the most significant bit

    assign out_any[0] = in[0]; // No right neighbour for the least significant bit
    assign out_any[1] = in[1] | in_shifted_right[1];
    assign out_any[2] = in[2] | in_shifted_right[2];
    assign out_any[3] = in[3] | in_shifted_right[3];

    assign out_different[0] = in[0] ^ in_aligned_different[0];
    assign out_different[1] = in[1] ^ in_aligned_different[1];
    assign out_different[2] = in[2] ^ in_aligned_different[2];
    assign out_different[3] = in[3] ^ in_aligned_different[3];

endmodule