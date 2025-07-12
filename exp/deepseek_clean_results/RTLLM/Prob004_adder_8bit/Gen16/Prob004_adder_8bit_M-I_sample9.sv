module adder_8bit #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input cin,
    output [WIDTH-1:0] sum,
    output cout
);

    // Carry chain with Manchester carry logic
    wire [WIDTH:0] carry;
    assign carry[0] = cin;

    // Intermediate signals for optimized logic
    wire [WIDTH-1:0] a_xor_b = a ^ b;
    wire [WIDTH-1:0] a_and_b = a & b;

    // Generate Manchester carry chain
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : carry_chain
            /* synthesis keep */  // Preserve carry chain for timing analysis
            assign carry[i+1] = a_and_b[i] | (carry[i] & ~a_xor_b[i]);
        end
    endgenerate

    // Sum calculation (XOR with carry)
    assign sum = a_xor_b ^ carry[WIDTH-1:0];

    // Final carry out
    assign cout = carry[WIDTH];

    /* Synthesis Optimization Directives:
     * 1. Manchester carry chain reduces propagation delay
     * 2. Shared intermediate signals minimize logic duplication
     * 3. XOR-based sum calculation has balanced delay
     * 4. 'keep' pragma ensures proper timing analysis
     * 
     * Power Gating Option:
     * // Add power gating control
     * // input  pg_enable;
     * // wire [WIDTH:0] carry_gated = pg_enable ? carry : {WIDTH+1{1'b0}};
     * // assign sum = pg_enable ? (a_xor_b ^ carry_gated[WIDTH-1:0]) : {WIDTH{1'b0}};
     * // assign cout = pg_enable ? carry_gated[WIDTH] : 1'b0;
     */

endmodule