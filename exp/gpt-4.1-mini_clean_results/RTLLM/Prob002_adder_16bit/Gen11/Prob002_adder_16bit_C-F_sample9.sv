module adder_4bit (
    input  [3:0] a,
    input  [3:0] b,
    input        Cin,
    output [3:0] y,
    output       Co
);
    wire [3:0] carry;
    wire [3:0] sum_bits;

    // 4-bit ripple carry adder with explicit carry chain using addition and carry chaining
    assign {carry[0], sum_bits[0]} = a[0] + b[0] + Cin;
    assign {carry[1], sum_bits[1]} = a[1] + b[1] + carry[0];
    assign {carry[2], sum_bits[2]} = a[2] + b[2] + carry[1];
    assign {carry[3], sum_bits[3]} = a[3] + b[3] + carry[2];

    assign y = sum_bits;
    assign Co = carry[3];
endmodule


module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire [7:0] p; // propagate signals for each bit
    wire [7:0] g; // generate signals for each bit
    wire [8:0] carry; // carry chain for 8 bits
    wire [3:0] low_sum, high_sum;
    wire carry_mid;

    // Calculate propagate and generate signals
    assign p = a ^ b;
    assign g = a & b;

    assign carry[0] = Cin;

    // Calculate carry for lower 4 bits using ripple carry inside low 4-bit adder
    adder_4bit low_adder (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(low_sum),
        .Co(carry_mid)
    );

    // Calculate carry signals for upper 4 bits explicitly:
    // For bits 4 to 7, compute carry ripple chain using propagate/generate and carry_mid
    assign carry[4] = carry_mid;

    // propagate and generate signals for upper nibble
    wire [3:0] p_high = p[7:4];
    wire [3:0] g_high = g[7:4];

    assign carry[5] = g_high[0] | (p_high[0] & carry[4]);
    assign carry[6] = g_high[1] | (p_high[1] & carry[5]);
    assign carry[7] = g_high[2] | (p_high[2] & carry[6]);
    assign carry[8] = g_high[3] | (p_high[3] & carry[7]);

    // Sum bits for upper 4 bits: y = p ^ carry (carry aligned)
    assign high_sum = p_high ^ carry[7:4];

    // Compose output sum and carry out
    assign y = {high_sum, low_sum};
    assign Co = carry[8];
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;

    // Instantiate lower 8-bit adder
    adder_8bit lower_8bit (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_mid)
    );

    // Instantiate upper 8-bit adder
    adder_8bit upper_8bit (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule