module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | ((a ^ b) & cin);
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire [3:0] carry;  // Carry bits (carry[3] is final carry-out)
    
    // Bit 0 (LSB)
    FullAdder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout(carry[0])
    );
    
    // Bit 1
    FullAdder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(carry[0]),
        .sum(sum[1]),
        .cout(carry[1])
    );
    
    // Bit 2
    FullAdder fa2(
        .a(x[2]),
        .b(y[2]),
        .cin(carry[1]),
        .sum(sum[2]),
        .cout(carry[2])
    );
    
    // Bit 3 (MSB)
    FullAdder fa3(
        .a(x[3]),
        .b(y[3]),
        .cin(carry[2]),
        .sum(sum[3]),
        .cout(carry[3])
    );
    
    // Overflow bit
    assign sum[4] = carry[3];
endmodule