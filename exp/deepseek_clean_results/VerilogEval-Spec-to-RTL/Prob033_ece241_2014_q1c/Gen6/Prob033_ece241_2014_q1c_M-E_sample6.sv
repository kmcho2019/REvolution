module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Compute sum conventionally
    assign s = a + b;
    
    // Early overflow detection using carry prediction
    wire carry_in = a[6] & b[6] | (a[6] ^ b[6]) & (a[5] & b[5] | (a[5] ^ b[5]) & 
                   (a[4] & b[4] | (a[4] ^ b[4]) & (a[3] & b[3] | (a[3] ^ b[3]) & 
                   (a[2] & b[2] | (a[2] ^ b[2]) & (a[1] & b[1] | (a[1] ^ b[1]) & 
                   (a[0] & b[0]))))));
    
    wire carry_out = a[7] & b[7] | (a[7] ^ b[7]) & carry_in;
    
    assign overflow = carry_in ^ carry_out;
endmodule