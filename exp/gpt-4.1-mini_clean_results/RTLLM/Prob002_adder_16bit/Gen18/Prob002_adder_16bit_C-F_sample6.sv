module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] sum,
    output       Cout
);
    wire [7:0] p; // propagate signals
    wire [7:0] g; // generate signals
    wire [7:1] c; // internal carries

    assign p = a ^ b; // propagate
    assign g = a & b; // generate

    // Carry for bit 1 to 7 computed sequentially (ripple style for clarity)
    assign c[1] = g[0] | (p[0] & Cin);
    genvar i;
    generate
        for (i = 2; i <= 7; i = i + 1) begin : carry_loop
            assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
        end
    endgenerate

    // Sum bits
    assign sum[0] = p[0] ^ Cin;
    generate
        for (i = 1; i <= 7; i = i + 1) begin : sum_loop
            assign sum[i] = p[i] ^ c[i];
        end
    endgenerate

    // Carry-out computed by carry look-ahead formula to improve delay on final carry
    assign Cout = g[7] | (p[7] & c[7]);
endmodule

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
        .sum(y[7:0]),
        .Cout(carry_mid)
    );

    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .sum(y[15:8]),
        .Cout(Co)
    );
endmodule