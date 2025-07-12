module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    wire [7:0] carry;
    
    // Carry computation using ternary operators
    assign carry[0] = (a[0] & b[0]) ? 1'b1 : (a[0] | b[0]) ? Cin : 1'b0;
    assign carry[1] = (a[1] & b[1]) ? 1'b1 : (a[1] | b[1]) ? carry[0] : 1'b0;
    assign carry[2] = (a[2] & b[2]) ? 1'b1 : (a[2] | b[2]) ? carry[1] : 1'b0;
    assign carry[3] = (a[3] & b[3]) ? 1'b1 : (a[3] | b[3]) ? carry[2] : 1'b0;
    assign carry[4] = (a[4] & b[4]) ? 1'b1 : (a[4] | b[4]) ? carry[3] : 1'b0;
    assign carry[5] = (a[5] & b[5]) ? 1'b1 : (a[5] | b[5]) ? carry[4] : 1'b0;
    assign carry[6] = (a[6] & b[6]) ? 1'b1 : (a[6] | b[6]) ? carry[5] : 1'b0;
    assign carry[7] = (a[7] & b[7]) ? 1'b1 : (a[7] | b[7]) ? carry[6] : 1'b0;
    
    // Sum remains same compact XOR implementation
    assign y = a ^ b ^ {carry[6:0], Cin};
    assign Co = carry[7];
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
    adder_8bit adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_middle)
    );
    
    // Upper 8-bit adder
    adder_8bit adder_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_middle),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule