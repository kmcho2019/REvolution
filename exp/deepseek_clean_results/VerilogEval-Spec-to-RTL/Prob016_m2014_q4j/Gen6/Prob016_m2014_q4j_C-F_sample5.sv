module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    // Efficient full adder implementation
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | ((a ^ b) & cin);
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire [2:0] carry;  // Only need 3 carry signals between 4 bits
    
    // Bit 0 adder (LSB)
    FullAdder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),     // No carry-in for LSB
        .sum(sum[0]),
        .cout(carry[0])
    );
    
    // Bit 1 adder
    FullAdder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(carry[0]),
        .sum(sum[1]),
        .cout(carry[1])
    );
    
    // Bit 2 adder
    FullAdder fa2(
        .a(x[2]),
        .b(y[2]),
        .cin(carry[1]),
        .sum(sum[2]),
        .cout(carry[2])
    );
    
    // Bit 3 adder (MSB) with carry-out becoming overflow
    FullAdder fa3(
        .a(x[3]),
        .b(y[3]),
        .cin(carry[2]),
        .sum(sum[3]),
        .cout(sum[4])   // Final carry-out becomes overflow bit
    );
endmodule