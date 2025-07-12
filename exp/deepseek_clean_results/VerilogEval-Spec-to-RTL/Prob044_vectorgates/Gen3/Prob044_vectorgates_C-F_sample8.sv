module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // Combined OR operations
    assign out_or_bitwise = a | b;
    assign out_or_logical = |(a | b);  // Most efficient logical OR implementation

    // Concatenated NOT operations
    assign out_not = {~b, ~a};  // Clean and compact bit placement

endmodule