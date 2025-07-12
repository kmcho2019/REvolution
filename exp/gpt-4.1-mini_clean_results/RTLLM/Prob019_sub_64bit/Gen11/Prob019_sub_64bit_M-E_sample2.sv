module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Divide operands into 16-bit chunks
    wire [15:0] A0 = A[15:0];
    wire [15:0] A1 = A[31:16];
    wire [15:0] A2 = A[47:32];
    wire [15:0] A3 = A[63:48];

    wire [15:0] B0 = B[15:0];
    wire [15:0] B1 = B[31:16];
    wire [15:0] B2 = B[47:32];
    wire [15:0] B3 = B[63:48];

    wire [15:0] R0, R1, R2, R3;
    wire borrow0, borrow1, borrow2, borrow3;

    // Chain 16-bit subtractors: A_chunk - B_chunk - borrow_in
    sub_16bit u_sub0(.A(A0), .B(B0), .borrow_in(1'b0),    .diff(R0), .borrow_out(borrow0));
    sub_16bit u_sub1(.A(A1), .B(B1), .borrow_in(borrow0), .diff(R1), .borrow_out(borrow1));
    sub_16bit u_sub2(.A(A2), .B(B2), .borrow_in(borrow1), .diff(R2), .borrow_out(borrow2));
    sub_16bit u_sub3(.A(A3), .B(B3), .borrow_in(borrow2), .diff(R3), .borrow_out(borrow3));

    assign result = {R3, R2, R1, R0};

    // Overflow detection:
    // overflow = (A_sign != B_sign) && (result_sign != A_sign)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 16-bit subtractor with borrow in/out using carry-lookahead addition logic
// Computes diff = A - B - borrow_in as A + (~B) + (~borrow_in + 1), managing borrow as carry
module sub_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        borrow_in,   // borrow_in acts like carry_in inverted (subtraction)
    output wire [15:0] diff,
    output wire        borrow_out
);
    // Compute two's complement subtraction: A - B - borrow_in = A + (~B) + (~borrow_in + 1)
    // For borrow_in = 0 => add 1, for borrow_in = 1 => add 0
    wire [15:0] B_neg = ~B;
    wire cin = ~borrow_in; // inverted borrow_in for addition

    wire [15:0] sum;
    wire cout;

    cla_16bit u_cla_16bit (
        .A   (A),
        .B   (B_neg),
        .cin (cin),
        .sum (sum),
        .cout(cout)
    );

    assign diff = sum;
    // borrow_out is inverted carry out because borrow_out = ~cout
    // If cout=0 => borrow generated = 1, else 0
    assign borrow_out = ~cout;

endmodule


// 16-bit Carry Lookahead Adder
module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        cin,
    output wire [15:0] sum,
    output wire        cout
);
    wire [15:0] P; // propagate
    wire [15:0] G; // generate
    wire [16:0] C; // carry chain

    assign P = A ^ B;
    assign G = A & B;

    assign C[0] = cin;

    // Carry lookahead logic per bit
    genvar i;
    generate
        for(i=0; i<16; i=i+1) begin : carry_gen
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    assign sum = P ^ C[15:0];
    assign cout = C[16];

endmodule