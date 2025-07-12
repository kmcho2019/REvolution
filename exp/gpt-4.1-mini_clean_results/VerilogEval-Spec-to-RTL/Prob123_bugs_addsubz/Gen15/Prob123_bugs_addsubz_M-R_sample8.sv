module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    wire [7:0] b_xor;          // Conditionally inverted b bits
    wire [8:0] carry;          // Carry signals
    wire [7:0] sum;            // Sum bits

    // Conditional inversion of b for subtraction
    assign b_xor = b ^ {8{do_sub}};

    // Initial carry-in is do_sub (1 for subtraction, 0 for addition)
    assign carry[0] = do_sub;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_bits
            assign sum[i] = a[i] ^ b_xor[i] ^ carry[i];
            if (i < 7) begin
                assign carry[i+1] = (a[i] & b_xor[i]) | (a[i] & carry[i]) | (b_xor[i] & carry[i]);
            end
        end
    endgenerate

    // Last carry out not used but driven to 0 to avoid undriven warnings
    assign carry[8] = 1'b0;

    // Outputs driven directly from combinational logic
    assign out = sum;
    assign result_is_zero = ~|sum;  // Reduction NOR to detect all-zero output

endmodule