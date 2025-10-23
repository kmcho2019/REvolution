module adder_8bit (
    input  [7:0]  a,
    input  [7:0]  b,
    input         Cin,
    output [7:0]  sum,
    output        Cout
);
    wire [8:0] carry;  // carry[0] = Cin, carry[8] = Cout
    assign carry[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_adders
            assign sum[i]   = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
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
    wire c8;

    // Lower 8-bit adder block
    adder_8bit u_lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(y[7:0]),
        .Cout(c8)
    );

    // Upper 8-bit adder block
    adder_8bit u_upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c8),
        .sum(y[15:8]),
        .Cout(Co)
    );
endmodule