// Module for logical-OR operation
module LogicalOR(
    input  [2:0] a,
    input  [2:0] b,
    output       out
);
    assign out = (a != 3'b000) || (b != 3'b000);
endmodule

// Top-level module with refactored operations
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    wire [2:0] inv_a, inv_b;

    // Directly implement bitwise-OR operation
    assign out_or_bitwise = a | b;

    // Instantiate LogicalOR module for logical-OR operation
    LogicalOR u_logical_or(
        .a(a),
        .b(b),
        .out(out_or_logical)
    );

    // Directly implement inversion operations
    assign inv_a = ~a;
    assign inv_b = ~b;

    // Assign inverted values to out_not
    assign out_not[5:3] = inv_b;
    assign out_not[2:0] = inv_a;
endmodule