// Full adder (1-bit adder) module with optimization for power and area
module full_adder(a, b, Cin, y, Co);
    input a, b, Cin;
    output y, Co;

    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// 8-bit carry-lookahead adder module for improved performance
module adder_8bit_cla(a, b, Cin, y, Co);
    input [7:0] a, b;
    input Cin;
    output [7:0] y;
    output Co;

    // Generate carries in parallel
    wire [7:0] g; // Carry generate
    wire [7:0] p; // Carry propagate
    wire [7:1] c; // Carry signals

    // Initialize carry-in for the first bit
    assign c[0] = Cin;

    // Generate and propagate signals
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            assign g[i] = a[i] & b[i];
            assign p[i] = a[i] | b[i];
        end
    endgenerate

    // Carry-lookahead logic
    assign c[1] = g[0] | (p[0] & c[0]);
    generate
        for (i = 2; i < 8; i++) begin
            assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
        end
    endgenerate

    // Sum generation
    generate
        for (i = 0; i < 8; i++) begin
            assign y[i] = a[i] ^ b[i] ^ c[i];
        end
    endgenerate

    // Carry-out
    assign Co = g[7] | (p[7] & c[7]);
endmodule

// 16-bit adder module using the optimized 8-bit adder
module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a, b;
    input Cin;
    output [15:0] y;
    output Co;

    wire Co_8bit;

    adder_8bit_cla adder_lo(a[7:0], b[7:0], Cin, y[7:0], Co_8bit);
    adder_8bit_cla adder_hi(a[15:8], b[15:8], Co_8bit, y[15:8], Co);
endmodule