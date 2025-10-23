module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] sum,
    output       Cout
);
    wire [8:0] carry; // carry[0] is input carry, carry[8] is output carry
    assign carry[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : ripple_adder
            // Sum bit calculation
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            // Carry-out calculation for next bit
            assign carry[i+1] = (a[i] & b[i]) | (carry[i] & (a[i] ^ b[i]));
        end
    endgenerate

    assign Cout = carry[8];
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;

    // Lower 8-bit ripple carry adder
    adder_8bit lower_block (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(y[7:0]),
        .Cout(carry_mid)
    );

    // Upper 8-bit ripple carry adder
    adder_8bit upper_block (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .sum(y[15:8]),
        .Cout(Co)
    );
endmodule