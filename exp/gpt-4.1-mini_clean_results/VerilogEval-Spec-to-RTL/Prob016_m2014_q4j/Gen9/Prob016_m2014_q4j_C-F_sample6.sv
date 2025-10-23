module FullAdder (
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

module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [4:0] carry;  // carry[0] = 0 initial carry-in

    assign carry[0] = 1'b0;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : adder_loop
            FullAdder fa (
                .a(x[i]),
                .b(y[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign sum[4] = carry[4]; // overflow bit
endmodule