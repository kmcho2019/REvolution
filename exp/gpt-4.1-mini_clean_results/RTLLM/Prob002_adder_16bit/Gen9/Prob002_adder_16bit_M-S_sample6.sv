module adder_1bit (
    input  a,
    input  b,
    input  Cin,
    output sum,
    output Co
);
    assign {Co, sum} = a + b + Cin;
endmodule

module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire [7:0] sum;
    wire [7:0] carry;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : full_adder_chain
            if (i == 0) begin
                adder_1bit fa (
                    .a(a[i]),
                    .b(b[i]),
                    .Cin(Cin),
                    .sum(sum[i]),
                    .Co(carry[i])
                );
            end else begin
                adder_1bit fa (
                    .a(a[i]),
                    .b(b[i]),
                    .Cin(carry[i-1]),
                    .sum(sum[i]),
                    .Co(carry[i])
                );
            end
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
    wire c8;

    adder_8bit lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(c8)
    );

    adder_8bit upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c8),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule