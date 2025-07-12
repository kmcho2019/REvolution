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

module TopModule #(
    parameter WIDTH = 4
)(
    input  [WIDTH-1:0] x,
    input  [WIDTH-1:0] y,
    output [WIDTH:0]   sum
);
    wire [WIDTH-1:0] carry;

    // First full adder with carry-in = 0
    FullAdder fa0 (
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout(carry[0])
    );

    genvar i;
    generate
        for (i = 1; i < WIDTH; i = i + 1) begin : adder_chain
            FullAdder fa (
                .a(x[i]),
                .b(y[i]),
                .cin(carry[i-1]),
                .sum(sum[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    // Assign the final carry-out as overflow bit
    assign sum[WIDTH] = carry[WIDTH-1];
endmodule