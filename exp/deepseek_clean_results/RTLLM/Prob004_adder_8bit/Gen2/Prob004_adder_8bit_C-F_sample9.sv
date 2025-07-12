module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Carry chain: carry_bit[0] = cin, carry_bit[8] = cout
    wire [8:0] carry_bit;
    
    assign carry_bit[0] = cin;  // Initialize carry chain
    
    // Generate full adders for each bit position
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_adder
            // Sum = a XOR b XOR carry_in
            assign sum[i] = a[i] ^ b[i] ^ carry_bit[i];
            
            // Carry_out = (a AND b) OR (carry_in AND (a OR b))
            assign carry_bit[i+1] = (a[i] & b[i]) | 
                                  (carry_bit[i] & (a[i] | b[i]));
        end
    endgenerate
    
    assign cout = carry_bit[8];  // Final carry out
    
endmodule