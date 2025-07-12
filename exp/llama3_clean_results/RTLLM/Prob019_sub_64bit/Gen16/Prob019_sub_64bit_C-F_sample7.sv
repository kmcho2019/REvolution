module sub_64bit(
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire         overflow
);

    wire [15:0] segA1, segA2, segA3, segA4;
    wire [15:0] segB1, segB2, segB3, segB4;
    wire [15:0] res1, res2, res3, res4;
    wire [15:0] temp1, temp2, temp3;
    wire borrow1, borrow2, borrow3;

    assign segA1 = A[15:0];
    assign segA2 = A[31:16];
    assign segA3 = A[47:32];
    assign segA4 = A[63:48];

    assign segB1 = B[15:0];
    assign segB2 = B[31:16];
    assign segB3 = B[47:32];
    assign segB4 = B[63:48];

    assign temp1 = segA1 - segB1;
    assign res1 = temp1;
    assign borrow1 = (segA1 < segB1) || (segA1 == segB1 && 1'b0);

    assign temp2 = segA2 - segB2 - borrow1;
    assign res2 = temp2;
    assign borrow2 = (segA2 < segB2) || (segA2 == segB2 && borrow1);

    assign temp3 = segA3 - segB3 - borrow2;
    assign res3 = temp3;
    assign borrow3 = (segA3 < segB3) || (segA3 == segB3 && borrow2);

    assign res4 = segA4 - segB4 - borrow3;

    assign result = {res4, res3, res2, res1};
    assign overflow = (A[63] == B[63] && A[63]!= result[63])? 1'b1 : 1'b0;

endmodule