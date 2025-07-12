// Optimized AND gate using assign statement
module AssignAnd (
    input a,
    input b,
    output out
);
    assign out = a & b;
endmodule

// Optimized AND gate using always block (direct reg output)
module AlwaysAnd (
    input a,
    input b,
    output reg out
);
    always @(*) out = a & b;
endmodule

// Top level module with optimized instantiations
module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    AssignAnd assign_inst (.*);  // Using .* for concise connections
    AlwaysAnd always_inst (.*);  // Same port names auto-connect
endmodule