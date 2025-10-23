module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Subtract A - B using four 16-bit CLA subtractor blocks with borrow chain

    wire borrow1, borrow2, borrow3, borrow4;

    wire [15:0] res0, res1, res2, res3;

    // Least significant 16 bits
    cla16_sub subtract_0 (
        .A   (A[15:0]),
        .B   (B[15:0]),
        .bin (1'b0),
        .diff(res0),
        .bout(borrow1)
    );

    // Next 16 bits
    cla16_sub subtract_1 (
        .A   (A[31:16]),
        .B   (B[31:16]),
        .bin (borrow1),
        .diff(res1),
        .bout(borrow2)
    );

    // Next 16 bits
    cla16_sub subtract_2 (
        .A   (A[47:32]),
        .B   (B[47:32]),
        .bin (borrow2),
        .diff(res2),
        .bout(borrow3)
    );

    // Most significant 16 bits
    cla16_sub subtract_3 (
        .A   (A[63:48]),
        .B   (B[63:48]),
        .bin (borrow3),
        .diff(res3),
        .bout(borrow4)
    );

    assign result = {res3, res2, res1, res0};

    // Overflow detection:
    // overflow = (A_sign != B_sign) && (result_sign != A_sign)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 16-bit Carry Lookahead Subtractor
// Performs diff = A - B - bin
// borrow-out = 1 if borrow occurs
module cla16_sub (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        bin,
    output wire [15:0] diff,
    output wire        bout
);
    wire [15:0] B_plus_bin;
    wire        carry_in_to_sub; // bin extended to addition style

    // To implement subtraction with borrow-in bin:
    // diff = A - B - bin = A + (~B) + (~bin + 1)
    // Actually we can treat bin as borrow in (borrow is 1 if we subtract one more)
    // Subtraction with borrow is equivalent to adding two's complement of (B + bin)
    // So compute B_plus_bin = B + bin
    wire carry_dummy;

    // B_plus_bin = B + bin (bin is 0 or 1)
    cla16_add add_b_bin (
        .A   (B),
        .B   ({15'b0, bin}),
        .cin (1'b0),
        .sum (B_plus_bin),
        .cout()
    );

    // Now diff = A + (~B_plus_bin) + 1
    // Implement diff = A + (~B_plus_bin) + 1
    wire [15:0] Bpn_comp = ~B_plus_bin;

    wire cout_sub;
    cla16_add add_sub (
        .A   (A),
        .B   (Bpn_comp),
        .cin (1'b1),
        .sum (diff),
        .cout(cout_sub)
    );

    // Borrow out = inverted cout_sub from addition equals borrow
    // Because subtraction borrow out is inverse of carry out from two's complement addition
    assign bout = ~cout_sub;

endmodule


// 16-bit Carry Lookahead Adder
module cla16_add (
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

    genvar i;
    generate
        for (i = 0; i < 16; i = i +1) begin : carry_loop
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    assign sum = P ^ C[15:0];
    assign cout = C[16];
endmodule