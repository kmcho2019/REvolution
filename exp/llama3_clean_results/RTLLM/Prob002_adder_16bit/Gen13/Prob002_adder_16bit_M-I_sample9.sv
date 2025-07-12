// Define the module for a 4-bit ripple-carry adder
module adder_4bit_rc(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);

    wire c1, c2, c3;

    // Bit 0
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign c1 = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

    // Bit 1
    assign y[1] = a[1] ^ b[1] ^ c1;
    assign c2 = (a[1] & b[1]) | (a[1] & c1) | (b[1] & c1);

    // Bit 2
    assign y[2] = a[2] ^ b[2] ^ c2;
    assign c3 = (a[2] & b[2]) | (a[2] & c2) | (b[2] & c2);

    // Bit 3
    assign y[3] = a[3] ^ b[3] ^ c3;
    assign Co = (a[3] & b[3]) | (a[3] & c3) | (b[3] & c3);

endmodule

// Define the module for an 8-bit carry-lookahead adder
module adder_8bit_cla(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    wire [7:0] g, p;
    wire [7:0] c;

    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] ^ b[0];
    assign c[0] = Cin;

    generate
        for (genvar i = 1; i < 8; i++) begin
            assign g[i] = a[i] & b[i];
            assign p[i] = a[i] ^ b[i];
            assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
        end
    endgenerate

    assign y[0] = p[0] ^ c[0];
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign y[i] = p[i] ^ c[i];
        end
    endgenerate
    assign Co = g[7] | (p[7] & c[7]);

endmodule

// Define the module for a 16-bit hybrid adder
module adder_16bit_hybrid(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    // Use ripple-carry adder for the least significant 8 bits
    wire [7:0] y_ls;
    wire co_ls;
    adder_8bit_rc adder_ls(
       .a(a[7:0]),
       .b(b[7:0]),
       .Cin(Cin),
       .y(y_ls),
       .Co(co_ls)
    );

    // Use carry-lookahead adder for the most significant 8 bits
    wire [7:0] y_ms;
    wire co_ms;
    adder_8bit_cla adder_ms(
       .a(a[15:8]),
       .b(b[15:8]),
       .Cin(co_ls),
       .y(y_ms),
       .Co(co_ms)
    );

    assign y[7:0] = y_ls;
    assign y[15:8] = y_ms;
    assign Co = co_ms;

endmodule

// Define the module for an 8-bit ripple-carry adder
module adder_8bit_rc(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    wire c1, c2, c3, c4, c5, c6, c7;

    // Bit 0
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign c1 = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

    // Bit 1
    assign y[1] = a[1] ^ b[1] ^ c1;
    assign c2 = (a[1] & b[1]) | (a[1] & c1) | (b[1] & c1);

    // Bit 2
    assign y[2] = a[2] ^ b[2] ^ c2;
    assign c3 = (a[2] & b[2]) | (a[2] & c2) | (b[2] & c3);

    // Bit 3
    assign y[3] = a[3] ^ b[3] ^ c3;
    assign c4 = (a[3] & b[3]) | (a[3] & c3) | (b[3] & c3);

    // Bit 4
    assign y[4] = a[4] ^ b[4] ^ c4;
    assign c5 = (a[4] & b[4]) | (a[4] & c4) | (b[4] & c4);

    // Bit 5
    assign y[5] = a[5] ^ b[5] ^ c5;
    assign c6 = (a[5] & b[5]) | (a[5] & c5) | (b[5] & c5);

    // Bit 6
    assign y[6] = a[6] ^ b[6] ^ c6;
    assign c7 = (a[6] & b[6]) | (a[6] & c6) | (b[6] & c6);

    // Bit 7
    assign y[7] = a[7] ^ b[7] ^ c7;
    assign Co = (a[7] & b[7]) | (a[7] & c7) | (b[7] & c7);

endmodule