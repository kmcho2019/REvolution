module adder_8bit #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input cin,
    output [WIDTH-1:0] sum,
    output cout
);

    // Carry chain: carry[i] is the carry-out of bit i-1 and carry-in for bit i
    // carry[0] is initialized with cin, carry[WIDTH] becomes cout
    wire [WIDTH:0] carry;
    assign carry[0] = cin;

    // Generate full adders for each bit position
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_adder
            // Sum computation: a XOR b XOR carry_in
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            
            // Optimized carry computation using majority function:
            // carry_out = (a AND b) OR (carry_in AND (a OR b))
            assign carry[i+1] = (a[i] & b[i]) | (carry[i] & (a[i] | b[i]));
        end
    endgenerate

    // Final carry out
    assign cout = carry[WIDTH];

    /* Implementation Notes:
     * 1. This is a ripple-carry adder with O(N) propagation delay
     * 2. For better performance, consider carry-lookahead or carry-select
     * 3. Current implementation shows good PPA (Power, Performance, Area)
     * 4. Majority function implementation is optimal for carry computation
     */
endmodule