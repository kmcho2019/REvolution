module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [8:0] carry; // carry[0] is carry-in, carry[8] is carry-out
    
    assign carry[0] = 1'b0;
    assign s = a ^ b ^ carry[7:0];
    assign carry[8:1] = (a & b) | ((a ^ b) & carry[7:0]);
    
    // Overflow detection (sign bits comparison)
    assign overflow = (a[7] == b[7]) & (a[7] != s[7]);
endmodule