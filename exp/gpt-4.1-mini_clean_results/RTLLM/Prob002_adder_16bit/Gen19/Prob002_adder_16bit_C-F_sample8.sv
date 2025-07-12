module cla_adder #(
    parameter WIDTH = 8
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input              Cin,
    output [WIDTH-1:0] y,
    output             Co
);
    wire [WIDTH-1:0] p; // propagate signals
    wire [WIDTH-1:0] g; // generate signals
    wire [WIDTH:1]   c; // internal carries

    assign p = a ^ b;
    assign g = a & b;

    // Carry look-ahead logic: linear chain for 8 bits or parameterized width
    assign c[1] = g[0] | (p[0] & Cin);
    genvar i;
    generate
        for (i = 2; i <= WIDTH; i = i + 1) begin : carry_gen
            assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
        end
    endgenerate

    assign Co = c[WIDTH];

    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : sum_gen
            assign y[i] = p[i] ^ ((i == 0) ? Cin : c[i]);
        end
    endgenerate
endmodule

module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;

    cla_adder #(.WIDTH(8)) lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_mid)
    );

    cla_adder #(.WIDTH(8)) upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule