// Define a module for a 1-bit full adder
module full_adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;
    
    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Define a module for a 16-bit carry-lookahead adder
module cla_16bit(a, b, cin, s, cout);
    input [16:1] a, b;
    input cin;
    output [16:1] s;
    output cout;
    
    wire [16:1] g, p;
    wire [15:0] c;
    
    // Calculate generate and propagate signals
    assign g[1] = a[1] & b[1];
    assign p[1] = a[1] | b[1];
    assign c[0] = cin;
    for (genvar i = 2; i <= 16; i++) begin
        assign g[i] = a[i] & b[i];
        assign p[i] = a[i] | b[i];
    end
    
    // Calculate carry signals using the generate and propagate signals
    assign c[0] = cin;
    for (genvar i = 1; i <= 15; i++) begin
        assign c[i] = g[i] | (p[i] & c[i-1]);
    end
    
    // Calculate sum signals
    assign cout = g[16] | (p[16] & c[15]);
    for (genvar i = 1; i <= 16; i++) begin
        assign s[i] = a[i] ^ b[i] ^ c[i-1];
    end
endmodule

// Define the top module for a 32-bit carry-lookahead adder
module adder_32bit(a, b, s, c32);
    input [32:1] a, b;
    output [32:1] s;
    output c32;
    
    wire c16;
    
    // Instantiate two 16-bit CLA blocks
    cla_16bit cla_low(a[16:1], b[16:1], 1'b0, s[16:1], c16);
    cla_16bit cla_high(a[32:17], b[32:17], c16, s[32:17], c32);
endmodule