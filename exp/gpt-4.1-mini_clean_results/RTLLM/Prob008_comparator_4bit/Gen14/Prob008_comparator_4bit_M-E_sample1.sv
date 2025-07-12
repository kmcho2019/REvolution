module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Internal wires for difference and borrow between bits
    wire [3:0] diff;
    wire [3:0] borrow;

    // Full subtractor for bit 0 (LSB)
    assign diff[0]   = A[0] ^ B[0];
    assign borrow[0] = (~A[0]) & B[0];

    // Full subtractor bit 1
    assign diff[1]   = A[1] ^ B[1] ^ borrow[0];
    assign borrow[1] = ((~A[1]) & B[1]) | (((~A[1]) | B[1]) & borrow[0]);

    // Full subtractor bit 2
    assign diff[2]   = A[2] ^ B[2] ^ borrow[1];
    assign borrow[2] = ((~A[2]) & B[2]) | (((~A[2]) | B[2]) & borrow[1]);

    // Full subtractor bit 3 (MSB)
    assign diff[3]   = A[3] ^ B[3] ^ borrow[2];
    assign borrow[3] = ((~A[3]) & B[3]) | (((~A[3]) | B[3]) & borrow[2]);

    // Determine if difference is zero
    wire diff_zero = &(~diff);

    // Borrow out from MSB indicates A < B
    wire A_less_wire = borrow[3];
    // If no borrow and diff not zero => A > B
    wire A_greater_wire = (~borrow[3]) & (~diff_zero);
    // If no borrow and diff zero => A == B
    wire A_equal_wire = (~borrow[3]) & diff_zero;

    assign A_less    = A_less_wire;
    assign A_greater = A_greater_wire;
    assign A_equal   = A_equal_wire;

endmodule