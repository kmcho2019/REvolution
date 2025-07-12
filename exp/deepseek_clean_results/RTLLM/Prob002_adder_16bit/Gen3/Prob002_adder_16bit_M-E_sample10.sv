module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    wire [8:0] carry;
    
    assign carry[0] = Cin;
    
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_loop
            assign y[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate
    
    assign Co = carry[8];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry_middle;
    wire [7:0] sum_high_0, sum_high_1;
    wire carry_high_0, carry_high_1;
    
    // Lower 8 bits (ripple carry)
    adder_8bit adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_middle)
    );
    
    // Upper 8 bits (compute both possibilities in parallel)
    adder_8bit adder_high_0 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(1'b0),
        .y(sum_high_0),
        .Co(carry_high_0)
    );
    
    adder_8bit adder_high_1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(1'b1),
        .y(sum_high_1),
        .Co(carry_high_1)
    );
    
    // Select correct result based on actual carry from lower bits
    assign y[15:8] = carry_middle ? sum_high_1 : sum_high_0;
    assign Co = carry_middle ? carry_high_1 : carry_high_0;
endmodule