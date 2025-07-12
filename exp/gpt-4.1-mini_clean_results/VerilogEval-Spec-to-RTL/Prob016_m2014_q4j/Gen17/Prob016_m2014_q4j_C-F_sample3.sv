module FullAdder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    wire axb = a ^ b;
    assign sum  = axb ^ cin;
    assign cout = (a & b) | (axb & cin);
endmodule

module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] carry;

    // Instantiate first full adder with cin = 0 explicitly
    FullAdder fa0 (
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout(carry[0])
    );

    // Generate block for bits 1 to 3
    genvar i;
    generate
        for (i = 1; i < 4; i = i + 1) begin : FA_GEN
            FullAdder fa (
                .a(x[i]),
                .b(y[i]),
                .cin(carry[i-1]),
                .sum(sum[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    // Final carry as overflow bit
    assign sum[4] = carry[3];
endmodule