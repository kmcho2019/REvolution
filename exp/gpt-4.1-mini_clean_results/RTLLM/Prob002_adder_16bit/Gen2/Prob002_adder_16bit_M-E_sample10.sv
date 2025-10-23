module full_adder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module adder_4bit (
    input  [3:0] a,
    input  [3:0] b,
    input        Cin,
    output [3:0] sum,
    output       Co
);
    wire [3:0] carry;

    // Instantiate full adders with carry chaining
    full_adder fa0 (
        .a(a[0]),
        .b(b[0]),
        .cin(Cin),
        .sum(sum[0]),
        .cout(carry[0])
    );

    genvar i;
    generate
        for(i = 1; i < 4; i = i + 1) begin : fa_loop
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i-1]),
                .sum(sum[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    assign Co = carry[3];
endmodule

module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire c1, c2, c3;

    adder_4bit adder0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .sum(y[3:0]),
        .Co(c1)
    );

    adder_4bit adder1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(c1),
        .sum(y[7:4]),
        .Co(c2)
    );

    adder_4bit adder2 (
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(c2),
        .sum(y[11:8]),
        .Co(c3)
    );

    adder_4bit adder3 (
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(c3),
        .sum(y[15:12]),
        .Co(Co)
    );
endmodule