// 1-bit full adder module
module adder_1bit(
    input a,
    input b,
    input Cin,
    output sum,
    output Cout
);
    
    assign sum = a ^ b ^ Cin;
    assign Cout = (a & b) | (a & Cin) | (b & Cin);
endmodule

// 4-bit carry-lookahead adder module
module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);
    
    // Generate sum and carry for each bit
    wire [3:0] sum;
    wire [3:0] carry;
    
    // 1-bit adder instances
    adder_1bit adder_0(
       .a(a[0]),
       .b(b[0]),
       .Cin(Cin),
       .sum(sum[0]),
       .Cout(carry[0])
    );
    
    adder_1bit adder_1(
       .a(a[1]),
       .b(b[1]),
       .Cin(carry[0]),
       .sum(sum[1]),
       .Cout(carry[1])
    );
    
    adder_1bit adder_2(
       .a(a[2]),
       .b(b[2]),
       .Cin(carry[1]),
       .sum(sum[2]),
       .Cout(carry[2])
    );
    
    adder_1bit adder_3(
       .a(a[3]),
       .b(b[3]),
       .Cin(carry[2]),
       .sum(sum[3]),
       .Cout(carry[3])
    );
    
    // Assign output
    assign y = sum;
    assign Co = carry[3];
endmodule

// 16-bit full adder module using 4-bit carry-lookahead adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    
    wire C4, C8, C12;
    
    // Instantiate four 4-bit carry-lookahead adders
    adder_4bit adder_lower(
       .a(a[3:0]),
       .b(b[3:0]),
       .Cin(Cin),
       .y(y[3:0]),
       .Co(C4)
    );
    
    adder_4bit adder_4bit_lower(
       .a(a[7:4]),
       .b(b[7:4]),
       .Cin(C4),
       .y(y[7:4]),
       .Co(C8)
    );
    
    adder_4bit adder_8bit_lower(
       .a(a[11:8]),
       .b(b[11:8]),
       .Cin(C8),
       .y(y[11:8]),
       .Co(C12)
    );
    
    adder_4bit adder_upper(
       .a(a[15:12]),
       .b(b[15:12]),
       .Cin(C12),
       .y(y[15:12]),
       .Co(Co)
    );
endmodule