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

// Define the module for a 4-bit carry-lookahead adder
module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);

    // Generate signals for carry lookahead
    wire [3:0] g;  // Generate signal
    wire [3:0] p;  // Propagate signal
    wire [2:0] c;  // Carry signal

    // Calculate generate and propagate signals
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] | b[0];

    for (genvar i = 1; i < 4; i++) begin
        assign g[i] = a[i] & b[i];
        assign p[i] = a[i] | b[i];
    end

    // Calculate carry signals
    assign c[0] = g[0] | (p[0] & Cin);
    for (genvar i = 1; i < 3; i++) begin
        assign c[i] = g[i] | (p[i] & c[i-1]);
    end

    // Calculate sum signals
    assign y[0] = a[0] ^ b[0] ^ Cin;
    for (genvar i = 1; i < 4; i++) begin
        assign y[i] = a[i] ^ b[i] ^ c[i-1];
    end

    // Calculate carry out
    assign Co = g[3] | (p[3] & c[2]);

endmodule

// Define the module for an 8-bit carry-lookahead adder
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    wire [3:0] c;

    // Instantiate two 4-bit adders
    adder_4bit adder_ls(
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(c[0])
    );

    adder_4bit adder_ms(
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(c[0]),
        .y(y[7:4]),
        .Co(Co)
    );

endmodule

// Define the module for a 16-bit carry-lookahead adder
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire c;

    // Instantiate two 8-bit adders
    adder_8bit adder_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(c)
    );

    adder_8bit adder_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule