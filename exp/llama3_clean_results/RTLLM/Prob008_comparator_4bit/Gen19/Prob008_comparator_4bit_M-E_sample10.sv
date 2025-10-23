module full_subtractor(
    input  a,
    input  b,
    input  borrow_in,
    output reg difference,
    output reg borrow_out
);

    assign difference = a - b - borrow_in;
    assign borrow_out = (~a & b) | (b & borrow_in) | (~a & borrow_in);

endmodule

module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output reg        A_greater,
    output reg        A_equal,
    output reg        A_less
);

    reg [3:0] result;
    reg [3:0] borrow;

    full_subtractor bit3(
       .a(A[3]),
       .b(B[3]),
       .borrow_in(1'b0),
       .difference(result[3]),
       .borrow_out(borrow[3])
    );

    full_subtractor bit2(
       .a(A[2]),
       .b(B[2]),
       .borrow_in(borrow[3]),
       .difference(result[2]),
       .borrow_out(borrow[2])
    );

    full_subtractor bit1(
       .a(A[1]),
       .b(B[1]),
       .borrow_in(borrow[2]),
       .difference(result[1]),
       .borrow_out(borrow[1])
    );

    full_subtractor bit0(
       .a(A[0]),
       .b(B[0]),
       .borrow_in(borrow[1]),
       .difference(result[0]),
       .borrow_out(borrow[0])
    );

    assign A_greater = (~borrow[0]) & (~result[0] & ~result[1] & ~result[2] & result[3]);
    assign A_equal = (~borrow[0]) & (~result[0] & ~result[1] & ~result[2] & ~result[3]);
    assign A_less = borrow[0];

endmodule