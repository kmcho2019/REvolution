module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Internal wires for borrow signals between 16-bit stages
    wire b0, b1, b2, b3;

    // 16-bit subtractor with borrow in and borrow out
    // Performs: diff = a - b - borrow_in
    // borrow_out = 1 if borrow occurs, else 0
    module sub16 (
        input  wire [15:0] a,
        input  wire [15:0] b,
        input  wire        borrow_in,
        output wire [15:0] diff,
        output wire        borrow_out
    );
        wire [16:0] tmp; // 17 bits to hold intermediate subtraction with borrow

        assign tmp = {1'b0, a} - {1'b0, b} - borrow_in;
        assign diff = tmp[15:0];
        assign borrow_out = ~tmp[16]; // If MSB is 0, borrow occurred
    endmodule

    // Instantiate four 16-bit subtractors chained by borrow
    sub16 stage0 (
        .a(A[15:0]),
        .b(B[15:0]),
        .borrow_in(1'b0),
        .diff(result[15:0]),
        .borrow_out(b0)
    );

    sub16 stage1 (
        .a(A[31:16]),
        .b(B[31:16]),
        .borrow_in(b0),
        .diff(result[31:16]),
        .borrow_out(b1)
    );

    sub16 stage2 (
        .a(A[47:32]),
        .b(B[47:32]),
        .borrow_in(b1),
        .diff(result[47:32]),
        .borrow_out(b2)
    );

    sub16 stage3 (
        .a(A[63:48]),
        .b(B[63:48]),
        .borrow_in(b2),
        .diff(result[63:48]),
        .borrow_out(b3) // final borrow not used here
    );

    // Overflow detection logic based on sign bits:
    wire sign_A      = A[63];
    wire sign_B      = B[63];
    wire sign_result = result[63];

    // Overflow occurs if:
    // - A positive, B negative, and result negative (positive overflow)
    // - A negative, B positive, and result positive (negative overflow)
    assign overflow = (sign_A != sign_B) && (sign_result != sign_A);

endmodule