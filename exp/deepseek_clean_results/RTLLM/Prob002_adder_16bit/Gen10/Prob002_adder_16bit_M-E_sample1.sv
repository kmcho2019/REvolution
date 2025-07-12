module adder_4bit (
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] sum,
    output Cout
);
    // Generate and propagate terms
    wire [3:0] g = a & b;
    wire [3:0] p = a | b;
    
    // Carry computation using parallel prefix
    wire [3:0] carry;
    assign carry[0] = g[0] | (p[0] & Cin);
    assign carry[1] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & Cin);
    assign carry[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & Cin);
    assign carry[3] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | 
                     (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & Cin);
    
    // Sum computation
    assign sum = a ^ b ^ {carry[2:0], Cin};
    assign Cout = carry[3];
endmodule

module carry_select_4bit (
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] sum,
    output Cout
);
    // Compute both possible sums
    wire [3:0] sum0, sum1;
    wire cout0, cout1;
    
    adder_4bit adder_c0 (.a(a), .b(b), .Cin(1'b0), .sum(sum0), .Cout(cout0));
    adder_4bit adder_c1 (.a(a), .b(b), .Cin(1'b1), .sum(sum1), .Cout(cout1));
    
    // Select correct result
    assign sum = Cin ? sum1 : sum0;
    assign Cout = Cin ? cout1 : cout0;
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire [3:0] carry;
    
    // First 4-bit block (ripple carry for initial segment)
    adder_4bit block0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .sum(y[3:0]),
        .Cout(carry[0])
    );
    
    // Generate carry-select blocks for remaining segments
    genvar i;
    generate
        for (i = 1; i < 4; i = i + 1) begin : adder_blocks
            carry_select_4bit block (
                .a(a[4*i+3 : 4*i]),
                .b(b[4*i+3 : 4*i]),
                .Cin(carry[i-1]),
                .sum(y[4*i+3 : 4*i]),
                .Cout(carry[i])
            );
        end
    endgenerate
    
    assign Co = carry[3];
endmodule