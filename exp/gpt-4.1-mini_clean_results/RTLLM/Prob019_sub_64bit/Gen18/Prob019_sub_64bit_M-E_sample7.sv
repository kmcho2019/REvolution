module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    wire [63:0] diff;
    wire [64:0] borrow;  // borrow chain: borrow[0] is initial borrow_in (0)
    assign borrow[0] = 1'b0;

    genvar i;
    generate
        for (i=0; i<64; i=i+1) begin : full_subtractor_chain
            full_subtractor u_sub (
                .a      (A[i]),
                .b      (B[i]),
                .borrow_in  (borrow[i]),
                .diff       (diff[i]),
                .borrow_out (borrow[i+1])
            );
        end
    endgenerate

    assign result = diff;

    // Overflow detection
    // overflow = (A[63] != B[63]) && (result[63] != A[63])
    wire A_sign = A[63];
    wire B_sign = B[63];
    wire R_sign = result[63];
    assign overflow = (A_sign ^ B_sign) & (R_sign ^ A_sign);

endmodule


// 1-bit full subtractor module
module full_subtractor (
    input  wire a,
    input  wire b,
    input  wire borrow_in,
    output wire diff,
    output wire borrow_out
);
    // diff = a - b - borrow_in = a ^ b ^ borrow_in
    assign diff = a ^ b ^ borrow_in;

    // borrow_out = (~a & b) | ((~a | b) & borrow_in)
    // Simplified expression for borrow_out in subtraction
    assign borrow_out = (~a & b) | ((~a | b) & borrow_in);
endmodule