module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Lower 4-bit chunk (always computed with carry-in=0)
    wire [3:0] sum_low = a[3:0] + b[3:0];
    wire carry_low = (a[3] & b[3]) | ((a[3] ^ b[3]) & (a[2] & b[2])) |
                   ((a[3] ^ b[3]) & (a[2] ^ b[2]) & (a[1] & b[1])) |
                   ((a[3] ^ b[3]) & (a[2] ^ b[2]) & (a[1] ^ b[1]) & (a[0] & b[0]));

    // Upper 4-bit chunks computed for both carry scenarios
    wire [3:0] sum_high_0 = a[7:4] + b[7:4];
    wire [3:0] sum_high_1 = a[7:4] + b[7:4] + 1;
    
    // Carry-out for both scenarios
    wire carry_high_0 = (a[7] & b[7]) | ((a[7] ^ b[7]) & (a[6] & b[6])) |
                       ((a[7] ^ b[7]) & (a[6] ^ b[6]) & (a[5] & b[5])) |
                       ((a[7] ^ b[7]) & (a[6] ^ b[6]) & (a[5] ^ b[5]) & (a[4] & b[4])));
    
    wire carry_high_1 = (a[7] & b[7]) | ((a[7] ^ b[7]) & (a[6] | b[6])) |
                       ((a[7] ^ b[7]) & (a[6] ^ b[6]) & (a[5] | b[5])) |
                       ((a[7] ^ b[7]) & (a[6] ^ b[6]) & (a[5] ^ b[5]) & (a[4] | b[4]));

    // Final result selection
    assign s = {carry_low ? sum_high_1 : sum_high_0, sum_low};
    
    // Overflow detection
    assign overflow = (carry_high_0 ^ carry_high_1) & 
                     ((carry_low & carry_high_1) | (~carry_low & carry_high_0));
endmodule