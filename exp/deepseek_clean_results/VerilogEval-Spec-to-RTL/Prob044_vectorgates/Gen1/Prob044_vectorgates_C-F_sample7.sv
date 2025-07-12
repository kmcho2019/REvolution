module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of a and b (shared with logical OR computation)
    assign out_or_bitwise = a | b;

    // More efficient logical OR using single reduction
    assign out_or_logical = |(a | b);

    // Concise NOT operations with concatenation
    assign out_not = {~b, ~a};

endmodule