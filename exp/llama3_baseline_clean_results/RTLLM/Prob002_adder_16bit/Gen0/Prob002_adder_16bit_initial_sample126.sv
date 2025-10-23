module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    wire [7:0] carry;

    assign carry[0] = Cin;
    assign Co = carry[7];

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .Cin(carry[i]),
                .y(y[i]),
                .Co(carry[i + 1])
            );
        end
    endgenerate

endmodule

module full_adder(
    input a,
    input b,
    input Cin,
    output y,
    output Co
);

    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);

endmodule

module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire carry;

    adder_8bit adder_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry)
    );

    adder_8bit adder_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule