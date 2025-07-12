module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Internal wires for borrow and result
    wire [3:0] result;
    wire [3:1] borrow;

    // Perform subtraction (A - B) using full subtractors
    full_subtractor fs0 (A[0], B[0], 1'b0, result[0], borrow[1]);
    full_subtractor fs1 (A[1], B[1], borrow[1], result[1], borrow[2]);
    full_subtractor fs2 (A[2], B[2], borrow[2], result[2], borrow[3]);
    full_subtractor fs3 (A[3], B[3], borrow[3], result[3], );

    // Determine the output based on the result and borrow
    assign A_greater = ~borrow[3] & (~(|result[3:0]));
    assign A_equal = ~(|result[3:0]) & borrow[3];
    assign A_less = borrow[3];

endmodule

// Full subtractor module
module full_subtractor (
    input a,
    input b,
    input borrow_in,
    output difference,
    output borrow_out
);

    assign difference = a ^ b ^ borrow_in;
    assign borrow_out = (~a & b) | (borrow_in & (~a | b));

endmodule