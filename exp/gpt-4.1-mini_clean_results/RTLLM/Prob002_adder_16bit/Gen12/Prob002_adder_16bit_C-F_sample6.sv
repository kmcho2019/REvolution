module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] sum,
    output       Cout
);
    wire [7:0] p;       // propagate signals
    wire [7:0] g;       // generate signals
    wire [8:0] carry;   // carry signals: carry[0] = Cin, carry[8] = Cout

    assign p = a ^ b;
    assign g = a & b;
    assign carry[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : carry_calc
            assign carry[i+1] = g[i] | (p[i] & carry[i]);
        end
    endgenerate

    // Explicit sum assignments for clarity and ease of debugging
    assign sum[0] = p[0] ^ carry[0];
    assign sum[1] = p[1] ^ carry[1];
    assign sum[2] = p[2] ^ carry[2];
    assign sum[3] = p[3] ^ carry[3];
    assign sum[4] = p[4] ^ carry[4];
    assign sum[5] = p[5] ^ carry[5];
    assign sum[6] = p[6] ^ carry[6];
    assign sum[7] = p[7] ^ carry[7];

    assign Cout = carry[8];
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_out_low;

    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(y[7:0]),
        .Cout(carry_out_low)
    );

    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_out_low),
        .sum(y[15:8]),
        .Cout(Co)
    );
endmodule