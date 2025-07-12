module adder_8bit(
    input [7:0] a, b,
    input Cin,
    output [7:0] y,
    output Co
);
    
    assign {Co, y} = a + b + Cin;
    
endmodule

module adder_16bit(
    input [15:0] a, b,
    input Cin,
    output [15:0] y,
    output Co
);
    
    wire [7:0] y_lower;
    wire [7:0] y_upper;
    wire Co_lower;
    
    adder_8bit u1(
        .a(a[7:0]), .b(b[7:0]), .Cin(Cin),
        .y(y_lower), .Co(Co_lower)
    );
    
    adder_8bit u2(
        .a(a[15:8]), .b(b[15:8]), .Cin(Co_lower),
        .y(y_upper), .Co(Co)
    );
    
    assign y = {y_upper, y_lower};
    
endmodule