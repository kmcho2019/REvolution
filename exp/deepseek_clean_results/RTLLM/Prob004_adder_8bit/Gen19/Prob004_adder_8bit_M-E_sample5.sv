module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // First 4-bit stage (ripple-carry)
    wire [3:0] sum_low;
    wire [4:0] carry_low;
    assign carry_low[0] = cin;
    
    // Bit 0
    assign sum_low[0] = a[0] ^ b[0] ^ carry_low[0];
    assign carry_low[1] = (a[0] & b[0]) | (carry_low[0] & (a[0] | b[0]));
    
    // Bit 1
    assign sum_low[1] = a[1] ^ b[1] ^ carry_low[1];
    assign carry_low[2] = (a[1] & b[1]) | (carry_low[1] & (a[1] | b[1]));
    
    // Bit 2
    assign sum_low[2] = a[2] ^ b[2] ^ carry_low[2];
    assign carry_low[3] = (a[2] & b[2]) | (carry_low[2] & (a[2] | b[2]));
    
    // Bit 3
    assign sum_low[3] = a[3] ^ b[3] ^ carry_low[3];
    assign carry_low[4] = (a[3] & b[3]) | (carry_low[3] & (a[3] | b[3]));
    
    // Second 4-bit stage (carry-select)
    wire [3:0] sum_high_0;  // Sum assuming carry-in=0
    wire [3:0] sum_high_1;  // Sum assuming carry-in=1
    wire [4:0] carry_high_0;
    wire [4:0] carry_high_1;
    
    assign carry_high_0[0] = 0;
    assign carry_high_1[0] = 1;
    
    // Generate both possible sums in parallel
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : upper_adder
            // Carry=0 path
            assign sum_high_0[i] = a[i+4] ^ b[i+4] ^ carry_high_0[i];
            assign carry_high_0[i+1] = (a[i+4] & b[i+4]) | (carry_high_0[i] & (a[i+4] | b[i+4]));
            
            // Carry=1 path
            assign sum_high_1[i] = a[i+4] ^ b[i+4] ^ carry_high_1[i];
            assign carry_high_1[i+1] = (a[i+4] & b[i+4]) | (carry_high_1[i] & (a[i+4] | b[i+4]));
        end
    endgenerate
    
    // Select correct sum and carry based on lower stage carry
    assign sum[3:0] = sum_low;
    assign sum[7:4] = carry_low[4] ? sum_high_1 : sum_high_0;
    assign cout = carry_low[4] ? carry_high_1[4] : carry_high_0[4];

endmodule