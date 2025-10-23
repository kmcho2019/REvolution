module FullAdder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] carry;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : FA_GEN
            FullAdder fa (
                .a(x[i]),
                .b(y[i]),
                .cin((i == 0) ? 1'b0 : carry[i-1]),
                .sum(sum[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    assign sum[4] = carry[3];
endmodule