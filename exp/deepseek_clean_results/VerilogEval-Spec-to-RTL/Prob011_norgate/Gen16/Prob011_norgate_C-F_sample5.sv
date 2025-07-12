/*
 * Parameterized Hierarchical NOR Gate Implementation
 * 
 * Features:
 * - Modular design with OR and NOT components
 * - Parameterized width for scalability
 * - Direct NOR operation in leaf module for optimal PPA
 * - Comprehensive documentation
 *
 * Truth Table (per bit):
 * a b | out
 * --------
 * 0 0 | 1
 * 0 1 | 0
 * 1 0 | 0
 * 1 1 | 0
 */

// Parameterized OR Gate Module
module OR_gate #(
    parameter WIDTH = 1
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [WIDTH-1:0] out
);
    assign out = a | b;
endmodule

// Parameterized NOT Gate Module
module NOT_gate #(
    parameter WIDTH = 1
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
    assign out = ~in;
endmodule

// Top Module implementing parameterized NOR using hierarchy
module TopModule #(
    parameter WIDTH = 1  // Default to 1-bit for current requirements
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [WIDTH-1:0] out
);
    wire [WIDTH-1:0] or_out;
    
    // Instantiate parameterized OR gate
    OR_gate #(.WIDTH(WIDTH)) or_inst (
        .a(a),
        .b(b),
        .out(or_out)
    );
    
    // Instantiate parameterized NOT gate
    NOT_gate #(.WIDTH(WIDTH)) not_inst (
        .in(or_out),
        .out(out)
    );
endmodule