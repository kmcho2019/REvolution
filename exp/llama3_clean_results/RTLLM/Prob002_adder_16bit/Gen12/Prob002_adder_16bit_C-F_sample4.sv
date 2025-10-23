// Define the module for a 4-bit carry-lookahead adder
module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);

    // Internal signals for generate and propagate
    wire [3:0] g, p;
    wire [3:0] c;

    // Calculate generate and propagate signals
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] ^ b[0];
    assign c[0] = Cin;

    generate
        for (genvar i = 1; i < 4; i++) begin
            assign g[i] = a[i] & b[i];
            assign p[i] = a[i] ^ b[i];
            assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
        end
    endgenerate

    // Calculate output and final carry
    assign y[0] = p[0] ^ c[0];
    generate
        for (genvar i = 1; i < 4; i++) begin
            assign y[i] = p[i] ^ c[i];
        end
    endgenerate
    assign Co = g[3] | (p[3] & c[3]);

endmodule

// Define the module for an 8-bit carry-lookahead adder using two 4-bit adders
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    wire C1;

    // Instantiate two 4-bit adders
    adder_4bit adder_ls(
      .a(a[3:0]),
      .b(b[3:0]),
      .Cin(Cin),
      .y(y[3:0]),
      .Co(C1)
    );

    adder_4bit adder_ms(
      .a(a[7:4]),
      .b(b[7:4]),
      .Cin(C1),
      .y(y[7:4]),
      .Co(Co)
    );

endmodule

// Define the module for a 16-bit full adder using two 8-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire C1;

    // Instantiate two 8-bit adders
    adder_8bit adder_ls(
      .a(a[7:0]),
      .b(b[7:0]),
      .Cin(Cin),
      .y(y[7:0]),
      .Co(C1)
    );

    adder_8bit adder_ms(
      .a(a[15:8]),
      .b(b[15:8]),
      .Cin(C1),
      .y(y[15:8]),
      .Co(Co)
    );

endmodule