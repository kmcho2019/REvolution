module full_adder (
    input  a,
    input  b,
    input  Cin,
    output sum,
    output Cout
);
    assign sum  = a ^ b ^ Cin;
    assign Cout = (a & b) | (b & Cin) | (a & Cin);
endmodule

module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire [7:0] sum;
    wire [7:0] carry;

    // First bit full adder
    full_adder fa0 (
        .a(a[0]),
        .b(b[0]),
        .Cin(Cin),
        .sum(sum[0]),
        .Cout(carry[0])
    );

    // Generate full adders for bits 1 to 7
    genvar i;
    generate
        for(i = 1; i < 8; i = i + 1) begin : fa_loop
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .Cin(carry[i-1]),
                .sum(sum[i]),
                .Cout(carry[i])
            );
        end
    endgenerate

    assign y = sum;
    assign Co = carry[7];
endmodule

module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire c_mid;
    wire [7:0] sum_low, sum_high;

    adder_8bit lower_half (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(sum_low),
        .Co(c_mid)
    );

    adder_8bit upper_half (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c_mid),
        .y(sum_high),
        .Co(Co)
    );

    assign y = {sum_high, sum_low};
endmodule