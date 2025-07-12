// Improved 8-bit full adder module using optimized carry-lookahead approach
module adder_8bit_cla_opt(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    // Calculate generate (g) and propagate (p) signals
    wire [7:0] g, p;
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] | b[0];
    
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign g[i] = a[i] & b[i];
            assign p[i] = a[i] | b[i];
        end
    endgenerate

    // Calculate carry (c) signals using optimized carry-lookahead logic
    wire [7:0] c;
    assign c[0] = Cin;
    assign c[1] = g[0] | (p[0] & Cin);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);

    // Calculate sum (y) signals
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign y[1] = a[1] ^ b[1] ^ c[1];
    assign y[2] = a[2] ^ b[2] ^ c[2];
    assign y[3] = a[3] ^ b[3] ^ c[3];
    assign y[4] = a[4] ^ b[4] ^ c[4];
    assign y[5] = a[5] ^ b[5] ^ c[5];
    assign y[6] = a[6] ^ b[6] ^ c[6];
    assign y[7] = a[7] ^ b[7] ^ c[7];

    // Assign carry-out (Co)
    assign Co = g[7] | (p[7] & c[7]);

endmodule

// 16-bit full adder module
module adder_16bit_opt(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire C1;

    // Instantiate two improved 8-bit adders
    adder_8bit_cla_opt adder_lower(
       .a(a[7:0]),
       .b(b[7:0]),
       .Cin(Cin),
       .y(y[7:0]),
       .Co(C1)
    );

    adder_8bit_cla_opt adder_upper(
       .a(a[15:8]),
       .b(b[15:8]),
       .Cin(C1),
       .y(y[15:8]),
       .Co(Co)
    );

endmodule