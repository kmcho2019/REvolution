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

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // Lower 4-bit ripple-carry block
    wire carry_low;
    wire [3:0] sum_low;
    adder_4bit low_adder (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(sum_low),
        .Co(carry_low)
    );
    
    // Middle 12-bit carry-select blocks (3x4bit)
    wire [2:0] carry_mid_0, carry_mid_1;
    wire [11:0] sum_mid_0, sum_mid_1;
    
    // Compute both possible carry chains in parallel
    adder_4bit mid_adder0_0 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(1'b0),
        .y(sum_mid_0[3:0]),
        .Co(carry_mid_0[0])
    );
    
    adder_4bit mid_adder0_1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(1'b1),
        .y(sum_mid_1[3:0]),
        .Co(carry_mid_1[0])
    );
    
    adder_4bit mid_adder1_0 (
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(carry_mid_0[0]),
        .y(sum_mid_0[7:4]),
        .Co(carry_mid_0[1])
    );
    
    adder_4bit mid_adder1_1 (
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(carry_mid_1[0]),
        .y(sum_mid_1[7:4]),
        .Co(carry_mid_1[1])
    );
    
    adder_4bit mid_adder2_0 (
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(carry_mid_0[1]),
        .y(sum_mid_0[11:8]),
        .Co(carry_mid_0[2])
    );
    
    adder_4bit mid_adder2_1 (
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(carry_mid_1[1]),
        .y(sum_mid_1[11:8]),
        .Co(carry_mid_1[2])
    );
    
    // Select correct carry chain
    wire [11:0] sum_mid_selected = carry_low ? sum_mid_1 : sum_mid_0;
    wire carry_mid_selected = carry_low ? carry_mid_1[2] : carry_mid_0[2];
    
    // Combine outputs
    assign y = {sum_mid_selected, sum_low};
    assign Co = carry_mid_selected;
endmodule