// Half Adder Module
module half_adder(
    input a,
    input b,
    output sum,
    output carry
);
    assign sum = a ^ b;
    assign carry = a & b;
endmodule

// Full Adder Module (using Half Adders)
module full_adder(
    input a,
    input b,
    input Cin,
    output sum,
    output Cout
);
    wire sum1, carry1;
    
    half_adder ha1(
       .a(a),
       .b(b),
       .sum(sum1),
       .carry(carry1)
    );
    
    half_adder ha2(
       .a(sum1),
       .b(Cin),
       .sum(sum),
       .carry(Cout)
    );
endmodule

// 8-bit Full Adder Module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Cout
);
    wire [6:0] carry;
    
    full_adder fa0(
       .a(a[0]),
       .b(b[0]),
       .Cin(Cin),
       .sum(y[0]),
       .Cout(carry[0])
    );
    
    generate
        for (genvar i = 1; i < 8; i++) begin
            full_adder fa(
               .a(a[i]),
               .b(b[i]),
               .Cin(carry[i-1]),
               .sum(y[i]),
               .Cout(carry[i])
            );
        end
    endgenerate
    
    assign Cout = carry[7];
endmodule

// 16-bit Full Adder Module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire Cout1;
    
    adder_8bit lower_bits(
       .a(a[7:0]),
       .b(b[7:0]),
       .Cin(Cin),
       .y(y[7:0]),
       .Cout(Cout1)
    );
    
    adder_8bit upper_bits(
       .a(a[15:8]),
       .b(b[15:8]),
       .Cin(Cout1),
       .y(y[15:8]),
       .Cout(Co)
    );
endmodule