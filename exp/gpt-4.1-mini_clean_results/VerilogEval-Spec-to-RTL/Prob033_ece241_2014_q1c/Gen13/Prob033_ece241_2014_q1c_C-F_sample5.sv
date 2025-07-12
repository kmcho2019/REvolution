module NBitCLAAdder #(
    parameter WIDTH = 8
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input              cin,
    output [WIDTH-1:0] sum,
    output             cout,
    output             carry_into_msb // carry into the most significant bit
);
    wire [WIDTH-1:0] p;  // propagate signals
    wire [WIDTH-1:0] g;  // generate signals
    wire [WIDTH:0]   c;  // carry signals, c[0]=cin, c[WIDTH]=cout

    assign p = a ^ b;
    assign g = a & b;

    assign c[0] = cin;

    // Carry-lookahead logic:
    // c[i+1] = g[i] | (p[i] & c[i])
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : carry_gen
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate

    assign sum = p ^ c[WIDTH-1:0];
    assign cout = c[WIDTH];
    assign carry_into_msb = c[WIDTH-1]; // carry into MSB bit (bit WIDTH-1)

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

    // Overflow detected by XOR of carry into MSB and carry out of MSB
    assign overflow = carry_into_msb ^ cout;

endmodule