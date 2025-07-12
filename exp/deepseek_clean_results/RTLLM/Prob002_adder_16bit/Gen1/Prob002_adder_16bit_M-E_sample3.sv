module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);
    assign {Co, y} = a + b + Cin;
endmodule

module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire [3:0] carry;
    wire [3:0] sum0_3, sum0_7, sum0_11, sum0_15;
    wire [3:0] sum1_3, sum1_7, sum1_11, sum1_15;
    
    // First 4-bit adder (bits 3:0)
    adder_4bit adder0(
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(carry[0])
    );
    
    // Second 4-bit segment (bits 7:4) - carry-select
    adder_4bit adder1_0(
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(1'b0),
        .y(sum0_7),
        .Co(carry[1])
    );
    adder_4bit adder1_1(
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(1'b1),
        .y(sum1_7),
        .Co(carry[2])
    );
    assign y[7:4] = carry[0] ? sum1_7 : sum0_7;
    wire carry7 = carry[0] ? carry[2] : carry[1];
    
    // Third 4-bit segment (bits 11:8) - carry-select
    adder_4bit adder2_0(
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(1'b0),
        .y(sum0_11),
        .Co(carry[3])
    );
    adder_4bit adder2_1(
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(1'b1),
        .y(sum1_11),
        .Co(carry[4])
    );
    assign y[11:8] = carry7 ? sum1_11 : sum0_11;
    wire carry11 = carry7 ? carry[4] : carry[3];
    
    // Fourth 4-bit segment (bits 15:12) - carry-select
    adder_4bit adder3_0(
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(1'b0),
        .y(sum0_15),
        .Co(carry[5])
    );
    adder_4bit adder3_1(
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(1'b1),
        .y(sum1_15),
        .Co(carry[6])
    );
    assign y[15:12] = carry11 ? sum1_15 : sum0_15;
    assign Co = carry11 ? carry[6] : carry[5];
endmodule