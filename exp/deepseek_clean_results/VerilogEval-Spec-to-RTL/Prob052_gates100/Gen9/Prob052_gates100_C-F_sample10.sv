module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Parameterized tree reduction for AND using recursive grouping
    function automatic logic tree_and;
        input [99:0] vec;
        begin
            tree_and = &vec; // Built-in reduction AND
        end
    endfunction

    // Parameterized tree reduction for OR using recursive grouping
    function automatic logic tree_or;
        input [99:0] vec;
        begin
            tree_or = |vec; // Built-in reduction OR
        end
    endfunction

    // Direct assignments using optimal reduction operators
    assign out_and = tree_and(in);
    assign out_or = tree_or(in);
    assign out_xor = ^in; // Built-in reduction XOR

endmodule