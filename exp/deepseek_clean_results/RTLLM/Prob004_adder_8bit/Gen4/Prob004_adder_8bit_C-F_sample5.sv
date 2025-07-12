module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [8:0] carry;  // Carry chain (includes cin and cout)
    
    assign carry[0] = cin;  // Initialize with input carry
    
    // Generate full adders for all 8 bits
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_chain
            // Sum bit calculation
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            // Carry-out calculation
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate
    
    assign cout = carry[8];  // Final carry out
    
endmodule