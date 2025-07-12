module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Generate and propagate terms
    wire [7:0] gen = a & b;
    wire [7:0] prop = a ^ b;
    
    // Carry computation (fully unrolled)
    wire c0 = gen[0];
    wire c1 = gen[1] | (prop[1] & c0);
    wire c2 = gen[2] | (prop[2] & c1);
    wire c3 = gen[3] | (prop[3] & c2);
    wire c4 = gen[4] | (prop[4] & c3);
    wire c5 = gen[5] | (prop[5] & c4);
    wire c6 = gen[6] | (prop[6] & c5);
    wire c7 = gen[7] | (prop[7] & c6);
    
    // Sum computation
    assign s = prop ^ {c6, c5, c4, c3, c2, c1, c0, 1'b0};
    
    // Overflow detection (sign bits comparison)
    assign overflow = (a[7] == b[7]) & (a[7] != s[7]);
endmodule