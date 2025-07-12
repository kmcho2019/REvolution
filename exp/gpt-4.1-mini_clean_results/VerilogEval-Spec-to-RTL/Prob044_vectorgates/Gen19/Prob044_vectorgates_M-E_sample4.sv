module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Intermediate wires for better reuse and clarity
    wire [2:0] or_result;
    wire [2:0] not_a;
    wire [2:0] not_b;

    assign or_result      = a | b;
    assign out_or_bitwise = or_result;
    assign out_or_logical = |or_result;  // Logical OR reduction of or_result
    assign not_a          = ~a;
    assign not_b          = ~b;
    assign out_not        = {not_b, not_a};

endmodule