module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [7:0] carry;
    
    // First bit (no carry-in)
    assign carry[0] = a[0] & b[0];
    assign s[0] = a[0] ^ b[0];
    
    // Middle bits
    assign carry[1] = (a[1] & b[1]) | ((a[1] ^ b[1]) & carry[0]);
    assign s[1] = a[1] ^ b[1] ^ carry[0];
    
    assign carry[2] = (a[2] & b[2]) | ((a[2] ^ b[2]) & carry[1]);
    assign s[2] = a[2] ^ b[2] ^ carry[1];
    
    assign carry[3] = (a[3] & b[3]) | ((a[3] ^ b[3]) & carry[2]);
    assign s[3] = a[3] ^ b[3] ^ carry[2];
    
    assign carry[4] = (a[4] & b[4]) | ((a[4] ^ b[4]) & carry[3]);
    assign s[4] = a[4] ^ b[4] ^ carry[3];
    
    assign carry[5] = (a[5] & b[5]) | ((a[5] ^ b[5]) & carry[4]);
    assign s[5] = a[5] ^ b[5] ^ carry[4];
    
    assign carry[6] = (a[6] & b[6]) | ((a[6] ^ b[6]) & carry[5]);
    assign s[6] = a[6] ^ b[6] ^ carry[5];
    
    assign carry[7] = (a[7] & b[7]) | ((a[7] ^ b[7]) & carry[6]);
    assign s[7] = a[7] ^ b[7] ^ carry[6];
    
    // Overflow detection (same as original)
    assign overflow = (a[7] == b[7]) && (s[7] != a[7]);
endmodule