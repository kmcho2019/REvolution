module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [8:0] c;  // Carry bits (one extra for overflow detection)
    
    assign c[0] = 0;  // Carry-in for LSB
    
    // Ripple-carry adder
    assign s = a ^ b ^ c[7:0];
    assign c[8:1] = (a & b) | ((a ^ b) & c[7:0]);
    
    // Overflow occurs when carry into MSB != carry out of MSB
    assign overflow = c[8] ^ c[7];
endmodule