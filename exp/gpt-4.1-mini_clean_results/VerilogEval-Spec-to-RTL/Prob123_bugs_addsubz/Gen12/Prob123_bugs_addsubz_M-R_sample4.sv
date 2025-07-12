module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    wire [7:0] b_invert;
    wire [7:0] sum;
    wire [7:0] carry;

    // Conditionally invert B based on do_sub (0 for add, 1 for subtract)
    assign b_invert = b ^ {8{do_sub}};

    // Initial carry-in is do_sub (0 for add, 1 for subtract)
    assign carry[0] = do_sub;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : ADD_SUB_BITS
            // sum bit calculation
            assign sum[i] = a[i] ^ b_invert[i] ^ carry[i];

            // carry propagation except for the MSB
            if (i < 7) begin
                assign carry[i+1] = (a[i] & b_invert[i]) | (a[i] & carry[i]) | (b_invert[i] & carry[i]);
            end
        end
    endgenerate

    // Output assignments as continuous combinational assignments
    assign out = sum;

    // result_is_zero is high if all bits of out are zero (reduction NOR)
    assign result_is_zero = ~|sum;

endmodule