module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Carry-select adder implementation (4+4 bits)
    wire [3:0] sum_low, sum_high0, sum_high1;
    wire carry_low, carry_high;
    
    // Lower 4-bit adder
    assign {carry_low, sum_low} = a[3:0] + b[3:0];
    
    // Upper 4-bit adders (with carry=0 and carry=1)
    assign sum_high0 = a[7:4] + b[7:4];
    assign sum_high1 = a[7:4] + b[7:4] + 1;
    
    // Final output mux
    assign s = {carry_low ? sum_high1 : sum_high0, sum_low};
    
    // Overflow detection using shared sign comparison
    wire same_sign = ~(a[7] ^ b[7]);
    assign overflow = same_sign & (a[7] ^ s[7]);
endmodule