// Define a 1-bit full adder
module full_adder(a, b, c_in, s, c_out);
    input a, b, c_in;
    output s, c_out;
    assign s = a ^ b ^ c_in;
    assign c_out = (a & b) | (a & c_in) | (b & c_in);
endmodule

// Define a 16-bit carry-lookahead adder
module cla_16bit(a, b, c_in, s, c_out);
    input [15:1] a, b;
    input c_in;
    output [15:1] s;
    output c_out;
    
    wire [15:1] g, p; // Generate and Propagate signals
    wire [15:1] c; // Carry signals
    
    // Calculate generate and propagate signals
    assign g[1] = a[1] & b[1];
    assign p[1] = a[1] | b[1];
    assign c[1] = g[1] | (p[1] & c_in);
    
    generate
        for (genvar i = 2; i <= 15; i++) begin
            assign g[i] = a[i] & b[i];
            assign p[i] = a[i] | b[i];
            assign c[i] = g[i] | (p[i] & c[i-1]);
        end
    endgenerate
    
    // Calculate sum
    assign s[1] = a[1] ^ b[1] ^ c_in;
    generate
        for (genvar i = 2; i <= 15; i++) begin
            assign s[i] = a[i] ^ b[i] ^ c[i-1];
        end
    endgenerate
    
    // Calculate carry-out
    assign c_out = g[15] | (p[15] & c[14]);
endmodule

// Define the 32-bit carry-lookahead adder
module adder_32bit(a, b, s, c32);
    input [32:1] a, b;
    output [32:1] s;
    output c32;
    
    wire c16; // Carry from lower 16 bits
    
    // Lower 16 bits
    cla_16bit lower_cla(.a(a[16:1]), .b(b[16:1]), .c_in(1'b0), .s(s[16:1]), .c_out(c16));
    
    // Upper 16 bits
    cla_16bit upper_cla(.a(a[32:17]), .b(b[32:17]), .c_in(c16), .s(s[32:17]), .c_out(c32));
endmodule