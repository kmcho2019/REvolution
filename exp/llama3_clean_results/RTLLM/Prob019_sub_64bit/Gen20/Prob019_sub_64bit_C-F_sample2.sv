module sub_16bit(
    input  logic [15:0] A,
    input  logic [15:0] B,
    input  logic         borrow_in,
    output logic [15:0] result,
    output logic         borrow_out
);

    assign result = A - B - borrow_in;
    assign borrow_out = (A < B) || (A == B && borrow_in);

endmodule

module sub_64bit(
    input  logic [63:0] A,
    input  logic [63:0] B,
    output logic [63:0] result,
    output logic         overflow
);

    logic [15:0] segA1, segA2, segA3, segA4;
    logic [15:0] segB1, segB2, segB3, segB4;
    logic [15:0] res1, res2, res3, res4;
    logic borrow1, borrow2, borrow3;

    assign segA1 = A[15:0];
    assign segA2 = A[31:16];
    assign segA3 = A[47:32];
    assign segA4 = A[63:48];

    assign segB1 = B[15:0];
    assign segB2 = B[31:16];
    assign segB3 = B[47:32];
    assign segB4 = B[63:48];

    sub_16bit u1(
       .A(segA1),
       .B(segB1),
       .borrow_in(1'b0),
       .result(res1),
       .borrow_out(borrow1)
    );

    sub_16bit u2(
       .A(segA2),
       .B(segB2),
       .borrow_in(borrow1),
       .result(res2),
       .borrow_out(borrow2)
    );

    sub_16bit u3(
       .A(segA3),
       .B(segB3),
       .borrow_in(borrow2),
       .result(res3),
       .borrow_out(borrow3)
    );

    sub_16bit u4(
       .A(segA4),
       .B(segB4),
       .borrow_in(borrow3),
       .result(res4)
    );

    assign result = {res4, res3, res2, res1};
    assign overflow = (A[63] == B[63] && A[63] != result[63]) ? 1'b1 : 1'b0;

    // Apply synthesis directives for area optimization and power reduction
    // synthesis attribute keep of u1 is true;
    // synthesis attribute keep of u2 is true;
    // synthesis attribute keep of u3 is true;
    // synthesis attribute keep of u4 is true;
    // synthesis attribute resource_sharing of u1 is true;
    // synthesis attribute resource_sharing of u2 is true;
    // synthesis attribute resource_sharing of u3 is true;
    // synthesis attribute resource_sharing of u4 is true;

    // Additional optimization: Consider using a carry-lookahead subtractor for the 16-bit segments
    // or investigate opportunities for resource sharing and area reduction during synthesis.

endmodule