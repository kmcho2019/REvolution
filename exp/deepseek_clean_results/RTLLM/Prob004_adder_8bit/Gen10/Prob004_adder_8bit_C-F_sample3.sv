module adder_8bit #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input cin,
    output [WIDTH-1:0] sum,
    output cout
);

    // Carry chain: carry[0] is cin, carry[WIDTH] is cout
    wire [WIDTH:0] carry;
    assign carry[0] = cin;

    // Generate full adders for each bit position
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : full_adder
            // Sum bit calculation: a XOR b XOR carry_in
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            
            // Carry out calculation:
            // (a AND b) OR (carry_in AND (a OR b))
            assign carry[i+1] = (a[i] & b[i]) | 
                              (carry[i] & (a[i] | b[i]));
        end
    endgenerate

    // Final carry out assignment
    assign cout = carry[WIDTH];

endmodule