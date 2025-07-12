module adder_4bit (
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);
    // Optimized 4-bit ripple-carry adder
    wire [3:0] g = a & b;
    wire [3:0] p = a ^ b;
    wire [4:0] c;
    
    assign c[0] = Cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
    
    assign y = p ^ c[3:0];
    assign Co = c[4];
endmodule

module carry_select_4bit (
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);
    // Two parallel 4-bit adders
    wire [3:0] sum0, sum1;
    wire co0, co1;
    
    adder_4bit adder_c0 (.a(a), .b(b), .Cin(1'b0), .y(sum0), .Co(co0));
    adder_4bit adder_c1 (.a(a), .b(b), .Cin(1'b1), .y(sum1), .Co(co1));
    
    // Mux selection based on actual carry-in
    assign y = Cin ? sum1 : sum0;
    assign Co = Cin ? co1 : co0;
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire [3:0] carry;
    
    // First 4 bits use ripple-carry (no benefit from carry-select)
    adder_4bit adder0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(carry[0])
    );
    
    // Remaining 12 bits use carry-select
    carry_select_4bit adder1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(carry[0]),
        .y(y[7:4]),
        .Co(carry[1])
    );
    
    carry_select_4bit adder2 (
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(carry[1]),
        .y(y[11:8]),
        .Co(carry[2])
    );
    
    carry_select_4bit adder3 (
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(carry[2]),
        .y(y[15:12]),
        .Co(Co)
    );
endmodule