module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] sum,
    output       Cout
);
    wire [7:0] c; // carry wires between bits, c[0] = Cin

    // Calculate sum and carry for each bit
    assign c[0] = Cin;

    assign sum[0] = a[0] ^ b[0] ^ c[0];
    assign c[1] = (a[0] & b[0]) | ((a[0] ^ b[0]) & c[0]);

    assign sum[1] = a[1] ^ b[1] ^ c[1];
    assign c[2] = (a[1] & b[1]) | ((a[1] ^ b[1]) & c[1]);

    assign sum[2] = a[2] ^ b[2] ^ c[2];
    assign c[3] = (a[2] & b[2]) | ((a[2] ^ b[2]) & c[2]);

    assign sum[3] = a[3] ^ b[3] ^ c[3];
    assign c[4] = (a[3] & b[3]) | ((a[3] ^ b[3]) & c[3]);

    assign sum[4] = a[4] ^ b[4] ^ c[4];
    assign c[5] = (a[4] & b[4]) | ((a[4] ^ b[4]) & c[4]);

    assign sum[5] = a[5] ^ b[5] ^ c[5];
    assign c[6] = (a[5] & b[5]) | ((a[5] ^ b[5]) & c[5]);

    assign sum[6] = a[6] ^ b[6] ^ c[6];
    assign c[7] = (a[6] & b[6]) | ((a[6] ^ b[6]) & c[6]);

    assign sum[7] = a[7] ^ b[7] ^ c[7];
    assign Cout = (a[7] & b[7]) | ((a[7] ^ b[7]) & c[7]);

endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;

    adder_8bit low8 (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(y[7:0]),
        .Cout(carry_mid)
    );

    adder_8bit high8 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .sum(y[15:8]),
        .Cout(Co)
    );

endmodule