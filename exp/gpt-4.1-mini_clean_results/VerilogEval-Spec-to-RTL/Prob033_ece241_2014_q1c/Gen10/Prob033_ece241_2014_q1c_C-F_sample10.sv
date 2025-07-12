module RippleCarryAdder #(
    parameter WIDTH = 4
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input              cin,
    output [WIDTH-1:0] sum,
    output             cout,
    output [WIDTH-1:0] carry // carry[i] = carry out of bit i
);
    // Generate bitwise full adders with explicit carries
    assign carry[0] = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);
    assign sum[0] = a[0] ^ b[0] ^ cin;

    genvar i;
    generate
        for (i = 1; i < WIDTH; i = i + 1) begin : gen_full_adder
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
            assign sum[i] = a[i] ^ b[i] ^ carry[i-1];
        end
    endgenerate

    assign cout = carry[WIDTH-1];
endmodule


module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [3:0] sum_lower, sum_upper;
    wire       carry_out_lower;
    wire [3:0] carry_lower, carry_upper;

    // Lower 4-bit adder
    RippleCarryAdder #(.WIDTH(4)) lower_adder (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(1'b0),
        .sum(sum_lower),
        .cout(carry_out_lower),
        .carry(carry_lower)
    );

    // Upper 4-bit adder, cin is carry_out of lower
    wire carry_out_upper;
    RippleCarryAdder #(.WIDTH(4)) upper_adder (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(carry_out_lower),
        .sum(sum_upper),
        .cout(carry_out_upper),
        .carry(carry_upper)
    );

    assign s = {sum_upper, sum_lower};

    // Overflow detection by XOR of carry into MSB and carry out of MSB:
    // carry into MSB (bit 7) = carry_upper[2] (carry out of bit 6)
    // carry out MSB (bit 7) = carry_upper[3]
    assign overflow = carry_upper[2] ^ carry_upper[3];

endmodule