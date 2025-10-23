module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Lower 4-bit ripple-carry adder
    wire [3:0] s_low = a[3:0] + b[3:0];
    wire carry_low = (a[3] & b[3]) | ((a[3] ^ b[3]) & (a[2] & b[2] | 
                    ((a[2] ^ b[2]) & (a[1] & b[1] | ((a[1] ^ b[1]) & 
                    (a[0] & b[0] | ((a[0] ^ b[0]) & 1'b0))))));

    // Upper 4-bit adders (both carry scenarios)
    wire [3:0] s_high_0, s_high_1;
    wire carry_high_0, carry_high_1;
    
    // Carry=0 scenario
    assign {carry_high_0, s_high_0} = a[7:4] + b[7:4] + 1'b0;
    // Carry=1 scenario
    assign {carry_high_1, s_high_1} = a[7:4] + b[7:4] + 1'b1;
    
    // Select correct upper sum based on lower carry
    assign s = {carry_low ? s_high_1 : s_high_0, s_low};
    
    // Speculative overflow detection (both scenarios)
    wire overflow_0 = (a[7] == b[7]) && (s_high_0[3] != a[7]);
    wire overflow_1 = (a[7] == b[7]) && (s_high_1[3] != a[7]);
    
    // Select correct overflow
    assign overflow = carry_low ? overflow_1 : overflow_0;
endmodule