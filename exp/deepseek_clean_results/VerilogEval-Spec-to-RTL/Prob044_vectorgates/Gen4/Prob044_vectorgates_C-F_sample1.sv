module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // Optimal bitwise OR implementation
    assign out_or_bitwise = a | b;

    // Most efficient logical OR implementation
    assign out_or_logical = |(a | b);

    // Efficient NOT operations with proper bit placement
    assign out_not = {~b, ~a};

endmodule