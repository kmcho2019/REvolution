// 1-bit full adder
module full_adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;
    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 16-bit carry-lookahead adder
module cla_16bit(a, b, cin, s, cout);
    input [16:1] a, b;
    input cin;
    output [16:1] s;
    output cout;
    wire [16:1] g, p; // generate and propagate signals
    wire [16:1] c; // carry signals

    // Calculate generate and propagate signals
    assign g[1] = a[1] & b[1];
    assign p[1] = a[1] | b[1];
    for (genvar i = 2; i <= 16; i++) begin
        assign g[i] = a[i] & b[i];
        assign p[i] = a[i] | b[i];
    end

    // Calculate carry signals
    assign c[1] = cin;
    for (genvar i = 2; i <= 16; i++) begin
        assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
    end

    // Calculate sum signals
    assign s[1] = a[1] ^ b[1] ^ cin;
    for (genvar i = 2; i <= 16; i++) begin
        assign s[i] = a[i] ^ b[i] ^ c[i-1];
    end

    // Calculate cout
    assign cout = g[16] | (p[16] & c[16]);
endmodule

// 32-bit carry-lookahead adder
module adder_32bit(a, b, s, c32);
    input [32:1] a, b;
    output [32:1] s;
    output c32;
    wire c16; // carry-out from lower 16 bits
    wire [16:1] s_lower, s_upper;

    // Lower 16 bits
    cla_16bit u1(a[16:1], b[16:1], 1'b0, s_lower, c16);

    // Upper 16 bits
    cla_16bit u2(a[32:17], b[32:17], c16, s_upper, c32);

    // Concatenate lower and upper 16 bits
    assign s[16:1] = s_lower;
    assign s[32:17] = s_upper;
endmodule