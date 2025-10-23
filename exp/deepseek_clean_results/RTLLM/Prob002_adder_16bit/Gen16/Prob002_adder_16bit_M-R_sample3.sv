module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    // Direct carry calculation without intermediate array
    wire c1 = (a[0] & b[0]) | ((a[0] | b[0]) & cin);
    wire c2 = (a[1] & b[1]) | ((a[1] | b[1]) & c1);
    wire c3 = (a[2] & b[2]) | ((a[2] | b[2]) & c2);
    wire c4 = (a[3] & b[3]) | ((a[3] | b[3]) & c3);
    wire c5 = (a[4] & b[4]) | ((a[4] | b[4]) & c4);
    wire c6 = (a[5] & b[5]) | ((a[5] | b[5]) & c5);
    wire c7 = (a[6] & b[6]) | ((a[6] | b[6]) & c6);
    wire c8 = (a[7] & b[7]) | ((a[7] | b[7]) & c7);

    assign sum = {a[7]^b[7]^c7, a[6]^b[6]^c6, a[5]^b[5]^c5,
                 a[4]^b[4]^c4, a[3]^b[3]^c3, a[2]^b[2]^c2,
                 a[1]^b[1]^c1, a[0]^b[0]^cin};
    assign cout = c8;
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry_middle;

    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .sum(y[7:0]),
        .cout(carry_middle)
    );

    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(carry_middle),
        .sum(y[15:8]),
        .cout(Co)
    );
endmodule