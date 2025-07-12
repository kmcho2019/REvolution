module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Internal wires for borrow chain between 16-bit subtractors
    wire borrow0, borrow1, borrow2, borrow3;

    // Chunk slices
    wire [15:0] A0 = A[15:0];
    wire [15:0] A1 = A[31:16];
    wire [15:0] A2 = A[47:32];
    wire [15:0] A3 = A[63:48];

    wire [15:0] B0 = B[15:0];
    wire [15:0] B1 = B[31:16];
    wire [15:0] B2 = B[47:32];
    wire [15:0] B3 = B[63:48];

    wire [15:0] R0, R1, R2, R3;

    // Instantiate 16-bit ripple borrow subtractors
    // borrow_in = 0 for least significant chunk subtraction

    sub16 sub0 (.A(A0), .B(B0), .borrow_in(1'b0),    .result(R0), .borrow_out(borrow0));
    sub16 sub1 (.A(A1), .B(B1), .borrow_in(borrow0), .result(R1), .borrow_out(borrow1));
    sub16 sub2 (.A(A2), .B(B2), .borrow_in(borrow1), .result(R2), .borrow_out(borrow2));
    sub16 sub3 (.A(A3), .B(B3), .borrow_in(borrow2), .result(R3), .borrow_out(borrow3));

    // Concatenate final result
    assign result = {R3, R2, R1, R0};

    // Overflow detection based on sign bits of inputs and result
    wire sign_A      = A[63];
    wire sign_B      = B[63];
    wire sign_result = result[63];

    // Overflow occurs if sign of A and B differ, and result's sign differs from A
    assign overflow = (sign_A != sign_B) && (sign_result != sign_A);

endmodule

// 16-bit ripple borrow subtractor module
// Inputs: A[15:0], B[15:0], borrow_in
// Outputs: result[15:0], borrow_out
// Implements result = A - B - borrow_in with borrow propagation
module sub16 (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        borrow_in,
    output wire [15:0] result,
    output wire        borrow_out
);
    wire [16:0] diff; // extended to hold borrow bit

    // Perform subtraction with borrow:
    // diff = A - B - borrow_in
    assign diff = {1'b0, A} - {1'b0, B} - borrow_in;

    assign result = diff[15:0];
    assign borrow_out = ~diff[16]; // borrow_out = 1 if diff < 0

endmodule