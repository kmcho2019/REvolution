module NBitCLAAdder #(
    parameter WIDTH = 8
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input              cin,
    output [WIDTH-1:0] sum,
    output             cout,
    output             carry_into_msb
);
    wire [WIDTH-1:0] p;
    wire [WIDTH-1:0] g;
    wire [WIDTH:0] c;

    assign p = a ^ b;
    assign g = a & b;
    assign c[0] = cin;

    // Explicit carry calculation without generate
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);
    assign c[8] = g[7] | (p[7] & c[7]);

    assign sum = p ^ c[WIDTH-1:0];
    assign cout = c[WIDTH];
    assign carry_into_msb = c[WIDTH-1];

endmodule


module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire cout;
    wire carry_into_msb;

    NBitCLAAdder #(.WIDTH(8)) cla_adder (
        .a(a),
        .b(b),
        .cin(1'b0),
        .sum(s),
        .cout(cout),
        .carry_into_msb(carry_into_msb)
    );

    assign overflow = carry_into_msb ^ cout;

endmodule