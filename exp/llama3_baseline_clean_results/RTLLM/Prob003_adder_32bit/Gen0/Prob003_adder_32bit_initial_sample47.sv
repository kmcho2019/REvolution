// Define the 1-bit full adder
module full_adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;
    
    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Define the 16-bit carry-lookahead adder
module cla_16bit(a, b, cin, s, cout);
    input [15:0] a, b;
    input cin;
    output [15:0] s;
    output cout;
    
    wire [15:0] g, p;
    wire [14:0] c;
    
    // Calculate G and P for each bit position
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] | b[0];
    assign c[0] = cin;
    
    genvar i;
    generate
        for (i = 1; i < 16; i++) begin
            assign g[i] = a[i] & b[i];
            assign p[i] = a[i] | b[i];
        end
    endgenerate
    
    // Calculate carry signals
    assign c[1] = g[0] | (p[0] & cin);
    generate
        for (i = 2; i < 16; i++) begin
            assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
        end
    endgenerate
    
    // Generate the sum bits
    assign s[0] = a[0] ^ b[0] ^ cin;
    generate
        for (i = 1; i < 16; i++) begin
            assign s[i] = a[i] ^ b[i] ^ c[i];
        end
    endgenerate
    
    // Generate the final carry out
    assign cout = g[15] | (p[15] & c[15]);
endmodule

// Define the top module: 32-bit carry-lookahead adder
module adder_32bit(a, b, s, c32);
    input [32:1] a, b;
    output [32:1] s;
    output c32;
    
    wire c16;
    
    // Instantiate two 16-bit CLA blocks
    cla_16bit u1(a[16:1], b[16:1], 1'b0, s[16:1], c16);
    cla_16bit u2(a[32:17], b[32:17], c16, s[32:17], c32);
endmodule