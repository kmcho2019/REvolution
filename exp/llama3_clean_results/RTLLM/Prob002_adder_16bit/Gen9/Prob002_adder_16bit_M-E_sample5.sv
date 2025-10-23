// Define the module for a half adder
module half_adder(
    input a,
    input b,
    output sum,
    output carry
);

    assign sum = a ^ b;
    assign carry = a & b;

endmodule

// Define the module for a full adder
module full_adder(
    input a,
    input b,
    input Cin,
    output sum,
    output Co
);

    wire sum_ab, carry_ab, carry_bc;

    half_adder ha1(
        .a(a),
        .b(b),
        .sum(sum_ab),
        .carry(carry_ab)
    );

    half_adder ha2(
        .a(sum_ab),
        .b(Cin),
        .sum(sum),
        .carry(carry_bc)
    );

    assign Co = carry_ab | carry_bc;

endmodule

// Define the module for an 8-bit adder
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    wire [6:0] carry;

    full_adder fa0(
        .a(a[0]),
        .b(b[0]),
        .Cin(Cin),
        .sum(y[0]),
        .Co(carry[0])
    );

    generate
        for (genvar i = 1; i < 8; i++) begin
            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .Cin(carry[i-1]),
                .sum(y[i]),
                .Co(carry[i])
            );
        end
    endgenerate

    assign Co = carry[7];

endmodule

// Define the module for a 16-bit full adder using two 8-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire carry_8bit;

    adder_8bit adder_ls(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_8bit)
    );

    adder_8bit adder_ms(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_8bit),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule