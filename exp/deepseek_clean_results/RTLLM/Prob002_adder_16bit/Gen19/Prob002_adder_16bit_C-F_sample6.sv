module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    // Explicit generate and propagate terms
    wire [7:0] g = a & b;  // Generate terms
    wire [7:0] p = a | b;  // Propagate terms
    wire [7:0] carry;
    
    // Optimized carry generation using g/p terms
    assign carry[0] = g[0] | (p[0] & cin);
    assign carry[1] = g[1] | (p[1] & carry[0]);
    assign carry[2] = g[2] | (p[2] & carry[1]);
    assign carry[3] = g[3] | (p[3] & carry[2]);
    assign carry[4] = g[4] | (p[4] & carry[3]);
    assign carry[5] = g[5] | (p[5] & carry[4]);
    assign carry[6] = g[6] | (p[6] & carry[5]);
    assign carry[7] = g[7] | (p[7] & carry[6]);
    
    // Direct sum calculation
    assign sum = a ^ b ^ {carry[6:0], cin};
    assign cout = carry[7];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry_middle;

    // Lower 8-bit adder
    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .sum(y[7:0]),
        .cout(carry_middle)
    );

    // Upper 8-bit adder
    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(carry_middle),
        .sum(y[15:8]),
        .cout(Co)
    );
endmodule