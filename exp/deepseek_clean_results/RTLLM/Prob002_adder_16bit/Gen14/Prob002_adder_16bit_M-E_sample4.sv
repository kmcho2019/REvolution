module adder_4bit (
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);
    wire [4:0] carry;
    
    assign carry[0] = Cin;
    assign carry[1] = (a[0] & b[0]) | ((a[0] | b[0]) & carry[0]);
    assign carry[2] = (a[1] & b[1]) | ((a[1] | b[1]) & carry[1]);
    assign carry[3] = (a[2] & b[2]) | ((a[2] | b[2]) & carry[2]);
    assign carry[4] = (a[3] & b[3]) | ((a[3] | b[3]) & carry[3]);
    
    assign y = a ^ b ^ carry[3:0];
    assign Co = carry[4];
endmodule

module carry_select_4bit (
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);
    wire [3:0] sum0, sum1;
    wire co0, co1;
    
    // Compute both possible sums in parallel
    adder_4bit adder_c0 (.a(a), .b(b), .Cin(1'b0), .y(sum0), .Co(co0));
    adder_4bit adder_c1 (.a(a), .b(b), .Cin(1'b1), .y(sum1), .Co(co1));
    
    // Select appropriate result based on actual carry-in
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
    
    // First 4-bit ripple-carry (no need for carry-select)
    adder_4bit adder0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(carry[0])
    );
    
    // Three 4-bit carry-select stages
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