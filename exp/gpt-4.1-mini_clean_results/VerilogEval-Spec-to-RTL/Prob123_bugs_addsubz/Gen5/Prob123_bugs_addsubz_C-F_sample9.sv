module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_xor;     // Conditionally inverted B for subtraction
    wire [7:0] sum;       // Sum bits
    wire [7:0] carry;     // Carry chain signals

    // Conditionally invert B bits based on do_sub (0 = add, 1 = subtract)
    assign b_xor = b ^ {8{do_sub}};

    // Initialize carry-in to do_sub (0 for add, 1 for subtract to add the +1)
    assign carry[0] = do_sub;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : ADDER_BITS
            // Full adder sum and carry-out for each bit:
            // sum = a ^ b_xor ^ carry_in
            // carry_out = majority(a, b_xor, carry_in)
            assign sum[i] = a[i] ^ b_xor[i] ^ carry[i];
            if (i < 7) begin
                assign carry[i+1] = (a[i] & b_xor[i]) | (a[i] & carry[i]) | (b_xor[i] & carry[i]);
            end
        end
    endgenerate

    always @(*) begin
        out = sum;
        result_is_zero = ~|sum;  // Reduction NOR for zero flag
    end

endmodule