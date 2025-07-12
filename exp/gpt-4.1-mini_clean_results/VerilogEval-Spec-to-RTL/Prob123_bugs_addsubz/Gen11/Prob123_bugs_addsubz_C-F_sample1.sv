module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_cond_inv;     // Conditionally inverted B bits
    wire [7:0] sum_bits;       // Sum bits from each full adder
    wire [8:0] carry;          // Carry chain signals, 9 bits for carry-out

    // Conditional inversion of B: XOR with do_sub
    assign b_cond_inv = b ^ {8{do_sub}};

    // Initialize carry-in to do_sub (0 for add, 1 for subtract)
    assign carry[0] = do_sub;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : FULL_ADDER_BITS
            // Full adder sum bit: XOR of a, B (conditionally inverted), and carry-in
            assign sum_bits[i] = a[i] ^ b_cond_inv[i] ^ carry[i];

            // Carry-out: majority function of the three inputs
            assign carry[i+1] = (a[i] & b_cond_inv[i]) | (a[i] & carry[i]) | (b_cond_inv[i] & carry[i]);
        end
    endgenerate

    always @(*) begin
        out = sum_bits;
        result_is_zero = ~|sum_bits;  // Reduction NOR to detect zero result
    end

endmodule