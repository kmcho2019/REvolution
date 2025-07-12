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
    // Propagate and generate signals
    wire [WIDTH-1:0] p;
    wire [WIDTH-1:0] g;
    // Carry signals c[0] to c[WIDTH], c[0] = cin, c[WIDTH] = cout
    wire [WIDTH:0] c;

    assign p = a ^ b;
    assign g = a & b;
    assign c[0] = cin;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : carry_loop
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate

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

    // Instantiate NBitCLAAdder once, producing sum and carry signals
    NBitCLAAdder #(.WIDTH(8)) cla_adder (
        .a(a),
        .b(b),
        .cin(1'b0),
        .sum(s),
        .cout(cout),
        .carry_into_msb(carry_into_msb)
    );

    // Overflow detected as XOR of carry into MSB and carry out of MSB
    assign overflow = carry_into_msb ^ cout;

endmodule