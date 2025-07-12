module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output reg [7:0] y,
    output reg       Co
);
    reg [7:0] carry;

    integer i;
    always @(*) begin
        carry[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);
        y[0] = a[0] ^ b[0] ^ Cin;
        for (i = 1; i < 8; i = i + 1) begin
            y[i] = a[i] ^ b[i] ^ carry[i-1];
            carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
        Co = carry[7];
    end
endmodule

module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire c_mid;
    wire [7:0] sum_low, sum_high;

    // Instantiate two 8-bit adders in cascade
    adder_8bit low_part (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(sum_low),
        .Co(c_mid)
    );

    adder_8bit high_part (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c_mid),
        .y(sum_high),
        .Co(Co)
    );

    assign y = {sum_high, sum_low};
endmodule