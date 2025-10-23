module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Group into two 4-bit blocks with carry lookahead
    wire [3:0] sum_low, sum_high;
    wire carry_mid;
    
    // First 4-bit block (bits 0-3)
    wire [3:0] p_low = a[3:0] ^ b[3:0];
    wire [3:0] g_low = a[3:0] & b[3:0];
    wire [3:0] c_low;
    
    assign c_low[0] = cin;
    assign c_low[1] = g_low[0] | (p_low[0] & c_low[0]);
    assign c_low[2] = g_low[1] | (p_low[1] & g_low[0]) | (p_low[1] & p_low[0] & c_low[0]);
    assign c_low[3] = g_low[2] | (p_low[2] & g_low[1]) | (p_low[2] & p_low[1] & g_low[0]) | 
                     (p_low[2] & p_low[1] & p_low[0] & c_low[0]);
    
    assign sum_low = p_low ^ c_low;
    assign carry_mid = g_low[3] | (p_low[3] & g_low[2]) | (p_low[3] & p_low[2] & g_low[1]) | 
                      (p_low[3] & p_low[2] & p_low[1] & g_low[0]) | 
                      (p_low[3] & p_low[2] & p_low[1] & p_low[0] & c_low[0]);
    
    // Second 4-bit block (bits 4-7)
    wire [3:0] p_high = a[7:4] ^ b[7:4];
    wire [3:0] g_high = a[7:4] & b[7:4];
    wire [3:0] c_high;
    
    assign c_high[0] = carry_mid;
    assign c_high[1] = g_high[0] | (p_high[0] & c_high[0]);
    assign c_high[2] = g_high[1] | (p_high[1] & g_high[0]) | (p_high[1] & p_high[0] & c_high[0]);
    assign c_high[3] = g_high[2] | (p_high[2] & g_high[1]) | (p_high[2] & p_high[1] & g_high[0]) | 
                      (p_high[2] & p_high[1] & p_high[0] & c_high[0]);
    
    assign sum_high = p_high ^ c_high;
    assign cout = g_high[3] | (p_high[3] & g_high[2]) | (p_high[3] & p_high[2] & g_high[1]) | 
                 (p_high[3] & p_high[2] & p_high[1] & g_high[0]) | 
                 (p_high[3] & p_high[2] & p_high[1] & p_high[0] & c_high[0]);
    
    // Combine results
    assign sum = {sum_high, sum_low};

endmodule