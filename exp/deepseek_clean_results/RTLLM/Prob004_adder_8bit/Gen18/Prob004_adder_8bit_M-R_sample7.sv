module adder_8bit #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input cin,
    output [WIDTH-1:0] sum,
    output cout
);

    // Carry chain with one extra bit for final carry out
    wire [WIDTH:0] carry;
    assign carry[0] = cin;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_adder
            wire a_or_b = a[i] | b[i];
            wire a_and_b = a[i] & b[i];
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = a_and_b | (carry[i] & a_or_b);
        end
    endgenerate

    // Final carry out assignment
    assign cout = carry[WIDTH];

    /* Synthesis Optimization Notes:
     * 1. The generate loop makes the code more maintainable and scalable
     * 2. Carry chain remains the critical path - same timing characteristics
     * 3. Power and area should be identical to bit-level version
     * 4. Synthesis tools can better optimize repeated structures
     */
endmodule