module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    wire [7:0] carry;
    
    assign carry[0] = cin;
    assign sum[0] = a[0] ^ b[0] ^ carry[0];
    
    genvar i;
    for (i = 1; i < 8; i = i + 1) begin
        assign carry[i] = (a[i-1] & b[i-1]) | (a[i-1] & carry[i-1]) | (b[i-1] & carry[i-1]);
        assign sum[i] = a[i] ^ b[i] ^ carry[i];
    end
    
    assign cout = (a[7] & b[7]) | (a[7] & carry[7]) | (b[7] & carry[7]);
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry_mid;
    
    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .sum(y[7:0]),
        .cout(carry_mid)
    );
    
    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(carry_mid),
        .sum(y[15:8]),
        .cout(Co)
    );
endmodule