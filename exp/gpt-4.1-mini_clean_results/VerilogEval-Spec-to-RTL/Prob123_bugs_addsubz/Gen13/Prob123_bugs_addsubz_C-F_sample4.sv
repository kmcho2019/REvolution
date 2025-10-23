module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    // Conditionally invert B for subtraction: XOR with all do_sub bits
    wire [7:0] b_invert = b ^ {8{do_sub}};

    // Carry chain for ripple carry addition; carry[0] is initial carry-in (do_sub)
    wire [8:0] carry;
    assign carry[0] = do_sub;

    // Sum bits from the ripple carry full adders
    wire [7:0] sum;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_bits
            // sum[i] = a[i] ^ b_invert[i] ^ carry[i]
            assign sum[i] = a[i] ^ b_invert[i] ^ carry[i];

            // carry[i+1] = majority(a[i], b_invert[i], carry[i])
            assign carry[i+1] = (a[i] & b_invert[i]) | (a[i] & carry[i]) | (b_invert[i] & carry[i]);
        end
    endgenerate

    // Assign output sum
    assign out = sum;

    // Result zero flag: reduction NOR of sum bits (true if all zero)
    assign result_is_zero = ~|sum;

endmodule