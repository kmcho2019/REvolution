module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    wire [64:0] borrow; // borrow chain signals, borrow[0] = initial borrow_in
    assign borrow[0] = 1'b0; // initial borrow in = 0 for subtraction

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : bit_subtractors
            sub1bit u_sub1bit (
                .A         (A[i]),
                .B         (B[i]),
                .borrow_in (borrow[i]),
                .difference(result[i]),
                .borrow_out(borrow[i+1])
            );
        end
    endgenerate

    // Overflow detection:
    // Overflow occurs if signs of A and B differ and the result sign differs from A's sign.
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 1-bit subtractor module with borrow in/out
module sub1bit (
    input  wire A,
    input  wire B,
    input  wire borrow_in,
    output wire difference,
    output wire borrow_out
);
    // difference = A ^ B ^ borrow_in
    assign difference = A ^ B ^ borrow_in;

    // borrow_out = (~A & B) | ((~A | B) & borrow_in)
    assign borrow_out = (~A & B) | ((~A | B) & borrow_in);

endmodule