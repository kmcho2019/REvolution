module adder_4bit_conditional (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    // Compute both possible sums (for carry=0 and carry=1)
    wire [3:0] sum0, sum1;
    wire cout0, cout1;
    
    // Carry=0 path
    assign sum0 = a ^ b;
    assign cout0 = (a[3] & b[3]) | 
                  ((a[3] | b[3]) & (a[2] & b[2])) |
                  ((a[3] | b[3]) & (a[2] | b[2]) & (a[1] & b[1])) |
                  ((a[3] | b[3]) & (a[2] | b[2]) & (a[1] | b[1]) & (a[0] & b[0]));
    
    // Carry=1 path
    assign sum1 = a ^ b ^ 4'b1111;
    assign cout1 = (a[3] & b[3]) | 
                  ((a[3] | b[3]) & (a[2] & b[2])) |
                  ((a[3] | b[3]) & (a[2] | b[2]) & (a[1] & b[1])) |
                  ((a[3] | b[3]) & (a[2] | b[2]) & (a[1] | b[1]) & (a[0] | b[0]));
    
    // Select appropriate result based on actual carry-in
    assign sum = cin ? sum1 : sum0;
    assign cout = cin ? cout1 : cout0;
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire [3:0] carry;
    
    // First 4-bit block (uses actual Cin)
    adder_4bit_conditional block0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(Cin),
        .sum(y[3:0]),
        .cout(carry[0])
    );
    
    // Subsequent blocks use ripple-carry with conditional sum optimization
    adder_4bit_conditional block1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(carry[0]),
        .sum(y[7:4]),
        .cout(carry[1])
    );
    
    adder_4bit_conditional block2 (
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(carry[1]),
        .sum(y[11:8]),
        .cout(carry[2])
    );
    
    adder_4bit_conditional block3 (
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(carry[2]),
        .sum(y[15:12]),
        .cout(Co)
    );
endmodule