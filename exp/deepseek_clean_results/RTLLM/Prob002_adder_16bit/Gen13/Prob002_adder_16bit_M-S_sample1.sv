module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    wire [8:0] carry = {a & b | (a | b) & {carry[7:0], Cin}};
    assign y = a ^ b ^ carry[7:0];
    assign Co = carry[8];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry_middle;
    
    adder_8bit adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_middle)
    );
    
    adder_8bit adder_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_middle),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule