// Define the module for a 1-bit full adder
module adder_1bit(
    input a,
    input b,
    input Cin,
    output y,
    output Co
);
    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// Define the module for an 8-bit full adder
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    wire [7:1] c;
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign c[1] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);
    assign y[1] = a[1] ^ b[1] ^ c[1];
    assign c[2] = (a[1] & b[1]) | (a[1] & c[1]) | (b[1] & c[1]);
    assign y[2] = a[2] ^ b[2] ^ c[2];
    assign c[3] = (a[2] & b[2]) | (a[2] & c[2]) | (b[2] & c[2]);
    assign y[3] = a[3] ^ b[3] ^ c[3];
    assign c[4] = (a[3] & b[3]) | (a[3] & c[3]) | (b[3] & c[3]);
    assign y[4] = a[4] ^ b[4] ^ c[4];
    assign c[5] = (a[4] & b[4]) | (a[4] & c[4]) | (b[4] & c[4]);
    assign y[5] = a[5] ^ b[5] ^ c[5];
    assign c[6] = (a[5] & b[5]) | (a[5] & c[5]) | (b[5] & c[5]);
    assign y[6] = a[6] ^ b[6] ^ c[6];
    assign c[7] = (a[6] & b[6]) | (a[6] & c[6]) | (b[6] & c[6]);
    assign y[7] = a[7] ^ b[7] ^ c[7];
    assign Co = (a[7] & b[7]) | (a[7] & c[7]) | (b[7] & c[7]);
endmodule

// Define the module for a 16-bit full adder using two 8-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire c8;
    // Instantiate the least significant 8-bit adder
    adder_8bit adder_ls(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(c8)
    );
    // Instantiate the most significant 8-bit adder
    adder_8bit adder_ms(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c8),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule