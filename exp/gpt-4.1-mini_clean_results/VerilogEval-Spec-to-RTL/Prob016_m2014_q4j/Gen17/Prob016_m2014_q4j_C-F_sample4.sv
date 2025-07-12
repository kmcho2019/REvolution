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

    // First full adder explicitly instantiated with cin = 0
    FullAdder fa0 (
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout(carry[0])
    );

    // Remaining full adders chained in a simple for loop (no generate)
    integer i;
    always @(*) begin
        for (i = 1; i < 4; i = i + 1) begin
            // combinational logic assignments inside always block not valid for module instantiation,
            // so we'll instead instantiate explicitly without generate, unrolled manually
        end
    end

endmodule