// Optimized assign-based AND gate
module AssignAnd (
    input a,
    input b,
    output out
);
    assign out = a & b;
endmodule

// Optimized always-block-based AND gate
module AlwaysAnd (
    input a,
    input b,
    output out
);
    always @(*) begin
        out = a & b;  // Direct assignment to output
    end
endmodule

// Top level module
module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Assign implementation instance
    AssignAnd assign_inst (
        .a(a),
        .b(b),
        .out(out_assign)
    );
    
    // Always block implementation instance
    AlwaysAnd always_inst (
        .a(a),
        .b(b),
        .out(out_alwaysblock)
    );
endmodule