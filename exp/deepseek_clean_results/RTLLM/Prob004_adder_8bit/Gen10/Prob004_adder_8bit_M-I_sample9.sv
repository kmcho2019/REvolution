module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // 4-bit carry-lookahead groups
    wire [1:0] g, p;  // Generate and propagate for each 4-bit block
    wire [1:0] c;     // Carry out for each block
    
    // First 4-bit block (bits 3:0)
    assign g[0] = (a[3] & b[3]) | ((a[2] & b[2]) | ((a[1] & b[1]) | (a[0] & b[0])));
    assign p[0] = (a[3] | b[3]) & (a[2] | b[2]) & (a[1] | b[1]) & (a[0] | b[0]);
    assign c[0] = g[0] | (p[0] & cin);
    
    // Second 4-bit block (bits 7:4)
    assign g[1] = (a[7] & b[7]) | ((a[6] & b[6]) | ((a[5] & b[5]) | (a[4] & b[4]));
    assign p[1] = (a[7] | b[7]) & (a[6] | b[6]) & (a[5] | b[5]) & (a[4] | b[4]);
    assign c[1] = g[1] | (p[1] & c[0]);
    assign cout = c[1];
    
    // Bit-level sum computation
    wire [7:0] carry;
    assign carry[0] = cin;
    
    generate
        genvar i;
        for (i=0; i<8; i=i+1) begin : bit_adder
            // Compute sum
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            
            // Compute next carry (optimized majority function)
            if (i < 7) begin
                assign carry[i+1] = (a[i] & b[i]) | (carry[i] & (a[i] | b[i]));
            end
            
            // Override carry at block boundaries with lookahead values
            if (i == 3) assign carry[i+1] = c[0];
            if (i == 7) assign carry[i+1] = c[1];
        end
    endgenerate

endmodule