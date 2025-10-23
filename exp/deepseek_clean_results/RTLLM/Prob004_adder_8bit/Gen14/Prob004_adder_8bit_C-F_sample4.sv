module adder_8bit #(
    parameter WIDTH = 8  // Makes the design scalable to other bit widths
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

    // Generate full adders for each bit
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : adder_chain
            // Intermediate signals for optimized carry logic
            wire a_or_b = a[i] | b[i];
            wire a_and_b = a[i] & b[i];
            
            // Sum and carry calculations
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = a_and_b | (carry[i] & a_or_b);
        end
    endgenerate

    // Final carry out assignment
    assign cout = carry[WIDTH];

    /* Synthesis Optimization Hints:
     * 1. The carry chain forms the critical path - consider carry-lookahead for >8 bits
     * 2. a_or_b and a_and_b signals help reduce redundant logic
     * 3. Structure is friendly for standard cell mapping
     */

endmodule