module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire [7:0] p;       // propagate
    wire [7:0] g;       // generate
    wire [8:0] carry;   // carry chain

    assign p = a ^ b;
    assign g = a & b;
    assign carry[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : carry_generate
            assign carry[i+1] = g[i] | (p[i] & carry[i]);
        end
    endgenerate

    assign y = p ^ carry[7:0];
    assign Co = carry[8];
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_out_lower;

    // Lower 8 bits adder
    adder_8bit adder_lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_out_lower)
    );

    // Upper 8 bits adder
    adder_8bit adder_upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_out_lower),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule