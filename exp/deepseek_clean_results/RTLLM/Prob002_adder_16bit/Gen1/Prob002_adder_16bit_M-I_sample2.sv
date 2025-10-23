module adder_4bit (
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);
    wire [4:0] sum;
    
    assign sum = a + b + Cin;
    assign y = sum[3:0];
    assign Co = sum[4];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire [3:0] carry;
    wire [15:0] sum0, sum1;
    wire [3:0] carry0, carry1;
    
    // First 4-bit adder (always uses input carry)
    adder_4bit adder0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(carry[0])
    );
    
    // Next three 4-bit adders implemented as carry-select
    // Compute both possible sums (with carry=0 and carry=1)
    adder_4bit adder1_0 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(1'b0),
        .y(sum0[7:4]),
        .Co(carry0[0])
    );
    
    adder_4bit adder1_1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(1'b1),
        .y(sum1[7:4]),
        .Co(carry1[0])
    );
    
    adder_4bit adder2_0 (
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(1'b0),
        .y(sum0[11:8]),
        .Co(carry0[1])
    );
    
    adder_4bit adder2_1 (
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(1'b1),
        .y(sum1[11:8]),
        .Co(carry1[1])
    );
    
    adder_4bit adder3_0 (
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(1'b0),
        .y(sum0[15:12]),
        .Co(carry0[2])
    );
    
    adder_4bit adder3_1 (
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(1'b1),
        .y(sum1[15:12]),
        .Co(carry1[2])
    );
    
    // Carry select logic
    assign y[7:4] = carry[0] ? sum1[7:4] : sum0[7:4];
    assign carry[1] = carry[0] ? carry1[0] : carry0[0];
    
    assign y[11:8] = carry[1] ? sum1[11:8] : sum0[11:8];
    assign carry[2] = carry[1] ? carry1[1] : carry0[1];
    
    assign y[15:12] = carry[2] ? sum1[15:12] : sum0[15:12];
    assign Co = carry[2] ? carry1[2] : carry0[2];
endmodule