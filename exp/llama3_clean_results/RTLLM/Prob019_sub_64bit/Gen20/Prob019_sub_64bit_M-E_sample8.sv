module sub_64bit_cla(
    input  logic [63:0] A,
    input  logic [63:0] B,
    output logic [63:0] result,
    output logic         overflow
);

    // Generate borrow signals using a parallel prefix tree
    logic [63:0] borrow;
    ppt_borrow_gen u_ppt(
        .A(A),
        .B(B),
        .borrow(borrow)
    );

    // Perform subtraction using the generated borrow signals
    logic [63:0] temp_result;
    assign temp_result = A - B - borrow;

    // Detect overflow by examining sign bits
    assign overflow = (A[63] == B[63] && A[63] != temp_result[63]) ? 1'b1 : 1'b0;

    // Assign final result
    assign result = temp_result;

endmodule

module ppt_borrow_gen(
    input  logic [63:0] A,
    input  logic [63:0] B,
    output logic [63:0] borrow
);

    // Level 1: Compute initial borrow signals
    logic [63:0] borrow_l1;
    assign borrow_l1 = (A < B) ? 1'b1 : 1'b0;

    // Level 2-6: Compute borrow signals using a parallel prefix tree
    logic [63:0] borrow_l2, borrow_l3, borrow_l4, borrow_l5, borrow_l6;
    assign borrow_l2 = borrow_l1[1:0]  | (A[1:0]  < B[1:0]);
    assign borrow_l3 = borrow_l2[3:0] | (A[3:0]  < B[3:0]);
    assign borrow_l4 = borrow_l3[7:0] | (A[7:0]  < B[7:0]);
    assign borrow_l5 = borrow_l4[15:0] | (A[15:0] < B[15:0]);
    assign borrow_l6 = borrow_l5[31:0] | (A[31:0] < B[31:0]);

    // Final borrow signals
    assign borrow = borrow_l6[63:0];

endmodule