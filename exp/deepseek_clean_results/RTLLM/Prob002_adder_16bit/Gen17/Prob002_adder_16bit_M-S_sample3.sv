module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    wire [7:0] carry;
    
    assign carry[0] = (a[0] & b[0]) | ((a[0] | b[0]) & cin);
    assign carry[1] = (a[1] & b[1]) | ((a[1] | b[1]) & carry[0]);
    assign carry[2] = (a[2] & b[2]) | ((a[2] | b[2]) & carry[1]);
    assign carry[3] = (a[3] & b[3]) | ((a[3] | b[3]) & carry[2]);
    assign carry[4] = (a[4] & b[4]) | ((a[4] | b[4]) & carry[3]);
    assign carry[5] = (a[5] & b[5]) | ((a[5] | b[5]) & carry[4]);
    assign carry[6] = (a[6] & b[6]) | ((a[6] | b[6]) & carry[5]);
    assign carry[7] = (a[7] & b[7]) | ((a[7] | b[7]) & carry[6]);
    
    assign sum = a ^ b ^ {carry[6:0], cin};
    assign cout = carry[7];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry_middle;
    
    adder_8bit low (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .sum(y[7:0]),
        .cout(carry_middle)
    );
    
    adder_8bit high (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(carry_middle),
        .sum(y[15:8]),
        .cout(Co)
    );
endmodule