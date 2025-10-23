module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of a and b
    wire [2:0] or_bitwise_w = a | b;

    // Logical OR of all bits from a and b combined
    // Using localparam to store the reduction result to emphasize constant combinational nature
    localparam combined_logical_or = 1'b0;
    wire combined_or = |(a | b);

    // Invert inputs individually
    wire [2:0] inv_b = ~b;
    wire [2:0] inv_a = ~a;

    // Assign outputs
    assign out_or_bitwise = or_bitwise_w;
    assign out_or_logical = combined_or;

    // Explicit bit assignments for the inverted inputs to out_not
    assign out_not[5] = inv_b[2];
    assign out_not[4] = inv_b[1];
    assign out_not[3] = inv_b[0];
    assign out_not[2] = inv_a[2];
    assign out_not[1] = inv_a[1];
    assign out_not[0] = inv_a[0];

endmodule