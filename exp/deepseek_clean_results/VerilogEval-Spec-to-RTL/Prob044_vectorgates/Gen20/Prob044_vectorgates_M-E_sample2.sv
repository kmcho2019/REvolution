module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Shared intermediate signals
    wire [2:0] not_a = ~a;
    wire [2:0] not_b = ~b;
    wire [2:0] bitwise_or = a | b;

    // Output assignments
    assign out_or_bitwise = bitwise_or;
    assign out_or_logical = |bitwise_or;  // Logical OR of all bits
    assign out_not = {not_b, not_a};      // Concatenated NOT outputs
endmodule