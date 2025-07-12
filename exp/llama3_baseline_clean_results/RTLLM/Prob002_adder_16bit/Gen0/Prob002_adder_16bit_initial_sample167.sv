module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    wire [7:0] sum;
    wire [7:0] carry;

    assign sum[0] = a[0] ^ b[0] ^ Cin;
    assign carry[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

    generate
        for (genvar i = 1; i < 8; i++) begin
            assign sum[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    endgenerate

    assign y = sum;
    assign Co = carry[7];

endmodule

module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire [7:0] sum_lo;
    wire [7:0] sum_hi;
    wire Co_lo;

    adder_8bit u_adder_lo(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(sum_lo),
        .Co(Co_lo)
    );

    adder_8bit u_adder_hi(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(Co_lo),
        .y(sum_hi),
        .Co(Co)
    );

    assign y[7:0] = sum_lo;
    assign y[15:8] = sum_hi;

endmodule