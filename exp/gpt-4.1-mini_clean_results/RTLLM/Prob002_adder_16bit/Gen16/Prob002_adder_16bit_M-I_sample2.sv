module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire [7:0] p; // propagate signals
    wire [7:0] g; // generate signals
    wire [8:1] c; // internal carry signals
    
    assign p = a ^ b;
    assign g = a & b;
    
    // Carry lookahead logic:
    // c[1] = g[0] | (p[0] & Cin)
    // c[2] = g[1] | (p[1] & c[1])
    // but we compute all carries in parallel using CLA logic:
    
    assign c[1] = g[0] | (p[0] & Cin);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);
    assign c[8] = g[7] | (p[7] & c[7]);
    
    // sum bits
    assign y = p ^ {c[7:1], Cin};
    assign Co = c[8];
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_out_lower;

    adder_8bit adder_lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_out_lower)
    );

    adder_8bit adder_upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_out_lower),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule