module FourBitAdder (
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout
);
    wire [4:0] full_sum;

    assign full_sum = {1'b0, a} + {1'b0, b} + cin;
    assign sum = full_sum[3:0];
    assign cout = full_sum[4];
endmodule


module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire lower_cout;
    wire [3:0] lower_sum, upper_sum;

    FourBitAdder lower_adder (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(1'b0),
        .sum(lower_sum),
        .cout(lower_cout)
    );

    wire upper_cout;
    FourBitAdder upper_adder (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(lower_cout),
        .sum(upper_sum),
        .cout(upper_cout)
    );

    assign s = {upper_sum, lower_sum};

    assign overflow = (a[7] & b[7] & ~s[7]) | (~a[7] & ~b[7] & s[7]);
endmodule