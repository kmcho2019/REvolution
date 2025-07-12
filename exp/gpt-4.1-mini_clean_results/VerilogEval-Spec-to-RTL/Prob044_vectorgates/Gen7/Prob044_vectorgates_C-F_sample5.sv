module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    wire [2:0] or_result;

    assign or_result = a | b;
    assign out_or_bitwise = or_result;
    assign out_or_logical = |or_result;
    assign out_not = {~b, ~a};

endmodule