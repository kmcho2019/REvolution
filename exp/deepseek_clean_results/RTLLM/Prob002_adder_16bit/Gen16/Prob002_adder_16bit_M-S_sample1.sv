module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    // Direct ripple carry implementation
    wire [7:0] c;
    
    assign {c[0], sum[0]} = a[0] + b[0] + cin;
    assign {c[1], sum[1]} = a[1] + b[1] + c[0];
    assign {c[2], sum[2]} = a[2] + b[2] + c[1];
    assign {c[3], sum[3]} = a[3] + b[3] + c[2];
    assign {c[4], sum[4]} = a[4] + b[4] + c[3];
    assign {c[5], sum[5]} = a[5] + b[5] + c[4];
    assign {c[6], sum[6]} = a[6] + b[6] + c[5];
    assign {c[7], sum[7]} = a[7] + b[7] + c[6];
    
    assign cout = c[7];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry_middle;

    // Lower 8-bit adder
    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .sum(y[7:0]),
        .cout(carry_middle)
    );

    // Upper 8-bit adder
    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(carry_middle),
        .sum(y[15:8]),
        .cout(Co)
    );
endmodule