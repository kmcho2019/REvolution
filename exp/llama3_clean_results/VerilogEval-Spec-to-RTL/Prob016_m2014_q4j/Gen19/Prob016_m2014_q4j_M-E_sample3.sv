// Module to generate carry bits
module CarryGen(
    input   logic [3:0] g, // Generate bits
    input   logic [3:0] p, // Propagate bits
    output  logic [3:0] c  // Carry bits
);

    assign c[0] = g[0];
    assign c[1] = g[1] | (p[1] & c[0]);
    assign c[2] = g[2] | (p[2] & c[1]);
    assign c[3] = g[3] | (p[3] & c[2]);

endmodule

// Module to generate sum bits
module SumGen(
    input   logic [3:0] x,
    input   logic [3:0] y,
    input   logic [3:0] c, // Carry bits
    output  logic [3:0] s  // Sum bits
);

    assign s[0] = x[0] ^ y[0] ^ 1'b0;
    assign s[1] = x[1] ^ y[1] ^ c[0];
    assign s[2] = x[2] ^ y[2] ^ c[1];
    assign s[3] = x[3] ^ y[3] ^ c[2];

endmodule

// TopModule with 4-bit adder
module TopModule(
    input   logic [3:0] x,
    input   logic [3:0] y,
    output  logic [4:0] sum
);

    wire logic [3:0] g; // Generate bits
    wire logic [3:0] p; // Propagate bits
    wire logic [3:0] c; // Carry bits
    wire logic [3:0] s; // Sum bits

    assign g[0] = x[0] & y[0];
    assign g[1] = x[1] & y[1];
    assign g[2] = x[2] & y[2];
    assign g[3] = x[3] & y[3];

    assign p[0] = x[0] | y[0];
    assign p[1] = x[1] | y[1];
    assign p[2] = x[2] | y[2];
    assign p[3] = x[3] | y[3];

    CarryGen carry_gen(.g(g), .p(p), .c(c));
    SumGen sum_gen(.x(x), .y(y), .c(c), .s(s));

    assign sum[0] = s[0];
    assign sum[1] = s[1];
    assign sum[2] = s[2];
    assign sum[3] = s[3];
    assign sum[4] = c[3];

endmodule