module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    wire [64:0] borrow; // borrow chain: borrow[0] = 0 initially
    assign borrow[0] = 1'b0;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : bit_sub
            sub_1bit u_sub_1bit (
                .a(A[i]),
                .b(B[i]),
                .borrow_in(borrow[i]),
                .diff(result[i]),
                .borrow_out(borrow[i+1])
            );
        end
    endgenerate

    wire sign_A      = A[63];
    wire sign_B      = B[63];
    wire sign_result = result[63];

    // Overflow detection logic for subtraction
    assign overflow = (sign_A != sign_B) && (sign_result != sign_A);

endmodule


// 1-bit subtractor with borrow in/out
module sub_1bit (
    input  wire a,
    input  wire b,
    input  wire borrow_in,
    output wire diff,
    output wire borrow_out
);
    // diff = a - b - borrow_in
    // borrow_out = (~a & b) | ((~a | b) & borrow_in)
    assign diff       = a ^ b ^ borrow_in;
    assign borrow_out = (~a & b) | ((~a | b) & borrow_in);
endmodule