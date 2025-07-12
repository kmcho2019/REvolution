module adder_8bit #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input cin,
    output [WIDTH-1:0] sum,
    output cout
);

    // Carry chain: carry[0] = cin, carry[WIDTH] = cout
    wire [WIDTH:0] carry;
    
    assign carry[0] = cin;  // Initialize carry chain with input carry
    
    // Generate full adders for each bit position
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_adder
            // Sum bit: a XOR b XOR carry_in
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            
            // Carry out: (a AND b) OR (carry_in AND (a OR b))
            assign carry[i+1] = (a[i] & b[i]) | 
                              (carry[i] & (a[i] | b[i]));
        end
    endgenerate
    
    assign cout = carry[WIDTH];  // Final carry out
    
endmodule