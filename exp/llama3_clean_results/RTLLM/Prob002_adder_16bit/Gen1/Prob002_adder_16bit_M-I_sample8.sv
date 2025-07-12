// Improved 8-bit full adder module using carry-lookahead approach
module adder_8bit_cla(
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

    // Calculate carry (c) signals using carry-lookahead logic
    wire [7:0] c;
    assign c[0] = Cin;
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
        end
    endgenerate

    // Calculate sum (y) signals
    assign y[0] = a[0] ^ b[0] ^ Cin;
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign y[i] = a[i] ^ b[i] ^ c[i];
        end
    endgenerate

    // Assign carry-out (Co)
    assign Co = g[7] | (p[7] & c[7]);

endmodule

// 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire C1;

    // Instantiate two improved 8-bit adders
    adder_8bit_cla adder_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(C1)
    );

    adder_8bit_cla adder_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(C1),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule