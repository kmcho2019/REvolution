module full_adder (
    input  a,
    input  b,
    input  Cin,
    output sum,
    output Cout
);
    assign sum = a ^ b ^ Cin;
    assign Cout = (a & b) | (a & Cin) | (b & Cin);
endmodule

module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire [7:0] carry;
    genvar i;

    // Instantiate first full adder with input carry Cin
    full_adder fa0 (
        .a(a[0]),
        .b(b[0]),
        .Cin(Cin),
        .sum(y[0]),
        .Cout(carry[0])
    );

    // Generate rest of full adders with carry chaining
    generate
        for (i = 1; i < 8; i = i + 1) begin : fa_loop
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .Cin(carry[i-1]),
                .sum(y[i]),
                .Cout(carry[i])
            );
        end
    endgenerate

    assign Co = carry[7];
endmodule

module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire c1;
    wire [7:0] sum_low, sum_high;

    // Instantiate lower 8-bit adder
    adder_8bit low_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(sum_low),
        .Co(c1)
    );

    // Instantiate upper 8-bit adder with carry from lower adder
    adder_8bit high_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c1),
        .y(sum_high),
        .Co(Co)
    );

    assign y = {sum_high, sum_low};
endmodule