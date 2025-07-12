module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Carry-lookahead logic for 4-bit blocks
    wire [1:0] g, p;  // Generate and propagate for each 4-bit block
    wire [1:0] c;     // Carry between blocks
    
    // First 4-bit block
    assign g[0] = (a[3] & b[3]) | ((a[2] & b[2]) | ((a[1] & b[1]) | (a[0] & b[0]));
    assign p[0] = (a[3] | b[3]) & (a[2] | b[2]) & (a[1] | b[1]) & (a[0] | b[0]);
    assign c[0] = g[0] | (p[0] & cin);
    
    // Second 4-bit block
    assign g[1] = (a[7] & b[7]) | ((a[6] & b[6]) | ((a[5] & b[5]) | (a[4] & b[4])));
    assign p[1] = (a[7] | b[7]) & (a[6] | b[6]) & (a[5] | b[5]) & (a[4] | b[4]);
    assign c[1] = g[1] | (p[1] & c[0]);
    assign cout = c[1];
    
    // Sum computation using optimized carry selection
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_adder
            if (i < 4) begin
                // First 4 bits use cin or block carry
                assign sum[i] = a[i] ^ b[i] ^ (i == 0 ? cin : 
                                             (i == 1 ? (a[0] & b[0]) | ((a[0] | b[0]) & cin) :
                                             (i == 2 ? (a[1] & b[1]) | ((a[1] | b[1]) & ((a[0] & b[0]) | ((a[0] | b[0]) & cin))) :
                                             c[0])));
            end else begin
                // Last 4 bits use block carry
                assign sum[i] = a[i] ^ b[i] ^ (i == 4 ? c[0] :
                                             (i == 5 ? (a[4] & b[4]) | ((a[4] | b[4]) & c[0]) :
                                             (i == 6 ? (a[5] & b[5]) | ((a[5] | b[5]) & ((a[4] & b[4]) | ((a[4] | b[4]) & c[0]))) :
                                             c[1]));
            end
        end
    endgenerate

endmodule