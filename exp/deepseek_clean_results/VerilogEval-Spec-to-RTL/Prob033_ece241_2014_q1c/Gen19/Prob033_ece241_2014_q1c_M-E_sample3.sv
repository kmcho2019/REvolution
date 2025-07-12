module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Lower 4-bit ripple-carry adder
    wire [4:0] carry_low;
    wire [3:0] sum_low;
    assign carry_low[0] = 1'b0;
    
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : low_adder
            assign sum_low[i] = a[i] ^ b[i] ^ carry_low[i];
            assign carry_low[i+1] = (a[i] & b[i]) | (a[i] & carry_low[i]) | (b[i] & carry_low[i]);
        end
    endgenerate
    
    // Upper 4-bit carry-select adder
    wire [4:0] carry_high_0, carry_high_1;
    wire [3:0] sum_high_0, sum_high_1;
    
    // Case when carry_in = 0
    assign carry_high_0[0] = 1'b0;
    generate
        for (i = 4; i < 8; i = i + 1) begin : high_adder_0
            assign sum_high_0[i-4] = a[i] ^ b[i] ^ carry_high_0[i-4];
            assign carry_high_0[i-3] = (a[i] & b[i]) | (a[i] & carry_high_0[i-4]) | (b[i] & carry_high_0[i-4]);
        end
    endgenerate
    
    // Case when carry_in = 1
    assign carry_high_1[0] = 1'b1;
    generate
        for (i = 4; i < 8; i = i + 1) begin : high_adder_1
            assign sum_high_1[i-4] = a[i] ^ b[i] ^ carry_high_1[i-4];
            assign carry_high_1[i-3] = (a[i] & b[i]) | (a[i] & carry_high_1[i-4]) | (b[i] & carry_high_1[i-4]);
        end
    endgenerate
    
    // Select upper sum based on lower carry
    wire [3:0] sum_high = carry_low[4] ? sum_high_1 : sum_high_0;
    wire carry_out = carry_low[4] ? carry_high_1[4] : carry_high_0[4];
    
    // Combine results
    assign s = {sum_high, sum_low};
    
    // Enhanced overflow detection
    wire sign_a = a[7];
    wire sign_b = b[7];
    wire sign_s = s[7];
    
    // Traditional method (carry in != carry out of MSB)
    wire traditional_overflow = carry_high_0[4] ^ carry_high_1[4];
    
    // Sign-based method (inputs same sign but result different)
    wire sign_overflow = (sign_a == sign_b) & (sign_a != sign_s);
    
    // Combined overflow detection
    assign overflow = traditional_overflow | sign_overflow;
endmodule