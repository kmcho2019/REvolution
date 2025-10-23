module FullAdder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    wire axb = a ^ b;
    assign sum = axb ^ cin;
    assign cout = (a & b) | (axb & cin);
endmodule

module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] carry;

    // First full adder with carry-in = 0
    FullAdder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout(carry[0])
    );

    genvar i;
    generate
        for (i = 1; i < 4; i = i + 1) begin : gen_full_adders
            FullAdder fa (
                .a(x[i]),
                .b(y[i]),
                .cin(carry[i-1]),
                .sum(sum[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    assign sum[4] = carry[3];  // Final carry-out as overflow bit
endmodule