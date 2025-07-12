module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    wire [2:0] a_or_b;
    assign a_or_b = a | b;
    assign out_or_bitwise = a_or_b;
    assign out_or_logical = |a_or_b;
    assign out_not = {~b, ~a};

endmodule