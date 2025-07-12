module BitwiseNOT #(
    parameter WIDTH = 3
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out_not
);
    assign out_not = ~in;
endmodule

module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    wire [2:0] not_a, not_b;
    assign out_or_bitwise = a | b;
    assign out_or_logical = |(a | b);

    BitwiseNOT #(.WIDTH(3)) inv_a (.in(a), .out_not(not_a));
    BitwiseNOT #(.WIDTH(3)) inv_b (.in(b), .out_not(not_b));

    assign out_not = {not_b, not_a};

endmodule