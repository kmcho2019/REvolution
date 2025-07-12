module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    wire [7:0] b_xor;       // Conditionally inverted B for subtraction
    wire [7:0] sum;         // Sum bits
    wire [8:0] carry;       // Carry chain signals (carry[0] is initial carry-in)

    assign b_xor = b ^ {8{do_sub}};
    assign carry[0] = do_sub;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_bits
            assign sum[i] = a[i] ^ b_xor[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b_xor[i]) | (a[i] & carry[i]) | (b_xor[i] & carry[i]);
        end
    endgenerate

    assign out = sum;
    assign result_is_zero = ~|sum;  // Reduction NOR of output

endmodule