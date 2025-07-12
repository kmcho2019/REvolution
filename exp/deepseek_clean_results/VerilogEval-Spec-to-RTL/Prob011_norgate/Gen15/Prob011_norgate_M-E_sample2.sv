/*
 * Hierarchical NOR Gate Implementation
 * 
 * Architecture:
 * - Uses separate OR and NOT gate modules
 * - Demonstrates hierarchical design methodology
 * - Functionally equivalent to direct NOR implementation
 * 
 * Advantages:
 * - Modular design for better testability
 * - Reusable components
 * - Clear separation of concerns
 */

// OR Gate Module
module OR_gate (
    input a,
    input b,
    output out
);
    assign out = a | b;
endmodule

// NOT Gate Module
module NOT_gate (
    input in,
    output out
);
    assign out = ~in;
endmodule

// Top Module implementing NOR using hierarchy
module TopModule (
    input a,
    input b,
    output out
);
    wire or_out;
    
    // Instantiate OR gate
    OR_gate or_inst (
        .a(a),
        .b(b),
        .out(or_out)
    );
    
    // Instantiate NOT gate
    NOT_gate not_inst (
        .in(or_out),
        .out(out)
    );
endmodule