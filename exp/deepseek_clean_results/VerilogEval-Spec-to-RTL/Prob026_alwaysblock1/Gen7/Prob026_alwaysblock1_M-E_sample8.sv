// Base AND gate module using assign statement
module AssignAnd (
    input a,
    input b,
    output out
);
    assign out = a & b;
endmodule

// Base AND gate module using always block
module AlwaysAnd (
    input a,
    input b,
    output out
);
    reg result;
    always @(*) begin
        result = a & b;
    end
    assign out = result;
endmodule

// Top level module instantiating both implementations
module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Instantiate assign-based AND gate
    AssignAnd assign_inst (
        .a(a),
        .b(b),
        .out(out_assign)
    );
    
    // Instantiate always-block-based AND gate
    AlwaysAnd always_inst (
        .a(a),
        .b(b),
        .out(out_alwaysblock)
    );
endmodule