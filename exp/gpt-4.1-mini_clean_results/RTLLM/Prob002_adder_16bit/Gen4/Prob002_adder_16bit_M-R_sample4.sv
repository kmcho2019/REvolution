// 1-bit full adder module
module full_adder_1bit (
    input  a,
    input  b,
    input  Cin,
    output sum,
    output Cout
);
    assign sum  = a ^ b ^ Cin;
    assign Cout = (a & b) | (a & Cin) | (b & Cin);
endmodule

// 8-bit adder composed of eight 1-bit full adders
module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire [7:0] carry; // carry between bits

    // Instantiate bit 0 full adder
    full_adder_1bit fa0 (
        .a(a[0]),
        .b(b[0]),
        .Cin(Cin),
        .sum(y[0]),
        .Cout(carry[0])
    );

    // Instantiate bits 1 to 7 full adders
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : fa_bits
            full_adder_1bit fa (
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

// 16-bit adder instantiating two 8-bit adders
module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;

    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_mid)
    );

    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule