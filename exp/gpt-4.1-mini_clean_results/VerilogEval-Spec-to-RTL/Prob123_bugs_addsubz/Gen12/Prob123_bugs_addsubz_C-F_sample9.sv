module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    wire [7:0] b_xor;
    wire [8:0] carry;
    wire [7:0] sum;

    // Conditional inversion of B for subtraction
    assign b_xor = b ^ {8{do_sub}};
    // Initial carry-in: 0 for addition, 1 for subtraction (to add two's complement)
    assign carry[0] = do_sub;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_bits
            assign sum[i] = a[i] ^ b_xor[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b_xor[i]) | (a[i] & carry[i]) | (b_xor[i] & carry[i]);
        end
    endgenerate

    assign out = sum;
    assign result_is_zero = ~|sum;  // Reduction NOR: 1 if out is zero, else 0

endmodule