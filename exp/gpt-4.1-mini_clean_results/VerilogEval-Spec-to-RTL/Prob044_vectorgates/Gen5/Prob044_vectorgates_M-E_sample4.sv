module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    wire a_any_set = |a;      // Reduction OR of 'a'
    wire b_any_set = |b;      // Reduction OR of 'b'

    assign out_or_bitwise = a | b;
    assign out_or_logical = a_any_set | b_any_set;
    assign out_not = {~b, ~a};

endmodule