module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    // Decode states using intermediate wires
    wire in_B = (~y[2]) & (~y[1]) & ( y[0]);  // state B (001)
    wire in_C = (~y[2]) & ( y[1]) & (~y[0]);  // state C (010)
    wire in_E = ( y[2]) & (~y[1]) & (~y[0]);  // state E (100)
    wire in_F = ( y[2]) & (~y[1]) & ( y[0]);  // state F (101)

    // Next y[1] bit logic separated for clarity
    wire next_y1 = in_B | (in_C & w) | (in_E & w) | in_F;

    assign Y1 = next_y1;

endmodule