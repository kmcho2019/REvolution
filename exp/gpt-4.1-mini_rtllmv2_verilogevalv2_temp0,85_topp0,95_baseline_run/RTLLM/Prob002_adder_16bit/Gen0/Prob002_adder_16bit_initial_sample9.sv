module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire [7:0] sum;
    wire [7:0] carry;

    assign {carry[0], sum[0]} = a[0] + b[0] + Cin;
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : adder_bit
            assign {carry[i], sum[i]} = a[i] + b[i] + carry[i-1];
        end
    endgenerate

    assign y = sum;
    assign Co = carry[7];
endmodule

module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire c_mid;

    // Instantiate lower 8-bit adder
    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(c_mid)
    );

    // Instantiate upper 8-bit adder
    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c_mid),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule