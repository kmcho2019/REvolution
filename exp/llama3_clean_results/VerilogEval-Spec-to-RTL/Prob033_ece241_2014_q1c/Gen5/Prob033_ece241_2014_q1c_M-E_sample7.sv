module TopModule(
    input  [7:0] a,  // 8-bit 2's complement input number
    input  [7:0] b,  // 8-bit 2's complement input number
    output [7:0] s,  // 8-bit result of the addition
    output      overflow  // indicator of signed overflow
);

    // Internal wires for the hybrid adder
    wire [3:0] sum_lo;
    wire [3:0] sum_hi;
    wire       carry_lo;
    wire       carry_hi;
    wire       carry_out;

    // 4-bit carry-lookahead adder for the lower 4 bits
    cla4 cla_lo(a[3:0], b[3:0], sum_lo, carry_lo);

    // 4-bit carry-lookahead adder for the upper 4 bits
    cla4 cla_hi(a[7:4], b[7:4], sum_hi, carry_hi);

    // Propagate the carry from the lower 4-bit adder to the upper 4-bit adder
    assign carry_out = carry_hi;

    // Assign the result of the addition
    assign s[3:0] = sum_lo;
    assign s[7:4] = sum_hi;

    // Detect signed overflow
    assign overflow = (a[7] == b[7] && a[7] != s[7]);

endmodule

// 4-bit carry-lookahead adder module
module cla4(
    input  [3:0] a,  // 4-bit input number
    input  [3:0] b,  // 4-bit input number
    output [3:0] sum,  // 4-bit result of the addition
    output      carry  // carry-out
);

    // Internal wires for the carry-lookahead logic
    wire [3:0] g;  // generate signals
    wire [3:0] p;  // propagate signals
    wire [2:0] c;  // carry signals

    // Calculate the generate and propagate signals
    assign g[0] = a[0] & b[0];
    assign g[1] = a[1] & b[1];
    assign g[2] = a[2] & b[2];
    assign g[3] = a[3] & b[3];
    assign p[0] = a[0] | b[0];
    assign p[1] = a[1] | b[1];
    assign p[2] = a[2] | b[2];
    assign p[3] = a[3] | b[3];

    // Calculate the carry signals
    assign c[0] = g[0];
    assign c[1] = g[1] | (p[1] & c[0]);
    assign c[2] = g[2] | (p[2] & c[1]);

    // Calculate the sum and carry-out
    assign sum[0] = a[0] ^ b[0] ^ c[0];
    assign sum[1] = a[1] ^ b[1] ^ c[1];
    assign sum[2] = a[2] ^ b[2] ^ c[2];
    assign sum[3] = a[3] ^ b[3] ^ c[2];
    assign carry = g[3] | (p[3] & c[2]);

endmodule