module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       Cin,
    output wire [7:0] y,
    output wire       Co
);
    wire [7:0] sum;
    wire [7:0] carry;

    // First bit addition
    assign {carry[0], sum[0]} = a[0] + b[0] + Cin;

    // Bits 1 to 7
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : add_bits
            assign {carry[i], sum[i]} = a[i] + b[i] + carry[i-1];
        end
    endgenerate

    assign y = sum;
    assign Co = carry[7];
endmodule

module adder_16bit (
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire        Cin,
    output wire [15:0] y,
    output wire        Co
);
    wire carry_mid;

    // Instantiate lower 8-bit adder
    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_mid)
    );

    // Instantiate upper 8-bit adder
    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule