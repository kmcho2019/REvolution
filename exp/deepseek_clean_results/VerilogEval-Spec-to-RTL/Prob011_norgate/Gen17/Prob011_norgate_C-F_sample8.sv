/*
 * Optimized Hierarchical NOR Gate
 * 
 * Features:
 * - Power-optimized using De Morgan's theorem (~a & ~b)
 * - Hierarchical design with reusable AND and NOT modules
 * - Parameterized width support
 * - Comprehensive documentation
 * 
 * Implementation Notes:
 * 1. Uses ~a & ~b instead of ~(a | b) for better power characteristics
 * 2. Modular design allows independent testing of components
 * 3. Parameterized for potential multi-bit operations
 */

// AND Gate Module (reusable)
module AND_gate #(
    parameter WIDTH = 1
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [WIDTH-1:0] out
);
    assign out = a & b;
endmodule

// NOT Gate Module (reusable)
module NOT_gate #(
    parameter WIDTH = 1
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
    assign out = ~in;
endmodule

// Top Module implementing optimized NOR
module TopModule #(
    parameter WIDTH = 1
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [WIDTH-1:0] out
);
    wire [WIDTH-1:0] not_a, not_b;
    
    /* Truth Table (per bit):
     * a b | out
     * --------
     * 0 0 | 1
     * 0 1 | 0
     * 1 0 | 0
     * 1 1 | 0
     */
    
    // First invert both inputs
    NOT_gate #(WIDTH) not_a_inst (
        .in(a),
        .out(not_a)
    );
    
    NOT_gate #(WIDTH) not_b_inst (
        .in(b),
        .out(not_b)
    );
    
    // Then AND the inverted inputs
    AND_gate #(WIDTH) and_inst (
        .a(not_a),
        .b(not_b),
        .out(out)
    );
endmodule