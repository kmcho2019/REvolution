// 1-bit full adder
module full_adder_1bit(
    input a,
    input b,
    input Cin,
    output y,
    output Co
);
    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// 8-bit full adder using 1-bit full adders
module full_adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    wire [7:0] carry;
    
    // Input carry for the first bit
    assign carry[0] = Cin;
    
    full_adder_1bit fa0(
       .a(a[0]),
       .b(b[0]),
       .Cin(carry[0]),
       .y(y[0]),
       .Co(carry[1])
    );
    
    full_adder_1bit fa1(
       .a(a[1]),
       .b(b[1]),
       .Cin(carry[1]),
       .y(y[1]),
       .Co(carry[2])
    );
    
    full_adder_1bit fa2(
       .a(a[2]),
       .b(b[2]),
       .Cin(carry[2]),
       .y(y[2]),
       .Co(carry[3])
    );
    
    full_adder_1bit fa3(
       .a(a[3]),
       .b(b[3]),
       .Cin(carry[3]),
       .y(y[3]),
       .Co(carry[4])
    );
    
    full_adder_1bit fa4(
       .a(a[4]),
       .b(b[4]),
       .Cin(carry[4]),
       .y(y[4]),
       .Co(carry[5])
    );
    
    full_adder_1bit fa5(
       .a(a[5]),
       .b(b[5]),
       .Cin(carry[5]),
       .y(y[5]),
       .Co(carry[6])
    );
    
    full_adder_1bit fa6(
       .a(a[6]),
       .b(b[6]),
       .Cin(carry[6]),
       .y(y[6]),
       .Co(carry[7])
    );
    
    full_adder_1bit fa7(
       .a(a[7]),
       .b(b[7]),
       .Cin(carry[7]),
       .y(y[7]),
       .Co(Co)
    );
endmodule

// 16-bit full adder using two 8-bit full adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire C8;
    
    full_adder_8bit fa_low(
       .a(a[7:0]),
       .b(b[7:0]),
       .Cin(Cin),
       .y(y[7:0]),
       .Co(C8)
    );
    
    full_adder_8bit fa_high(
       .a(a[15:8]),
       .b(b[15:8]),
       .Cin(C8),
       .y(y[15:8]),
       .Co(Co)
    );
endmodule