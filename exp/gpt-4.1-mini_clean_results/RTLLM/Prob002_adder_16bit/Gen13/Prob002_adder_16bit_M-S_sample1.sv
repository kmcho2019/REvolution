module full_adder (
    input  a,
    input  b,
    input  Cin,
    output sum,
    output Cout
);
    assign sum  = a ^ b ^ Cin;
    assign Cout = (a & b) | (b & Cin) | (a & Cin);
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

    generate
        for(i = 0; i < 8; i = i + 1) begin : full_adders
            if(i == 0) begin
                full_adder fa(
                    .a(a[i]),
                    .b(b[i]),
                    .Cin(Cin),
                    .sum(y[i]),
                    .Cout(carry[i])
                );
            end else begin
                full_adder fa(
                    .a(a[i]),
                    .b(b[i]),
                    .Cin(carry[i-1]),
                    .sum(y[i]),
                    .Cout(carry[i])
                );
            end
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
    wire carry_mid;

    adder_8bit lower_8bit (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_mid)
    );

    adder_8bit upper_8bit (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule