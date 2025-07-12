module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Tree reduction function for AND operation
    function automatic logic tree_and;
        input [99:0] vec;
        begin
            tree_and = &vec;  // Built-in reduction AND is optimal
        end
    endfunction

    // Tree reduction function for OR operation
    function automatic logic tree_or;
        input [99:0] vec;
        begin
            tree_or = |vec;   // Built-in reduction OR is optimal
        end
    endfunction

    // Assign outputs
    assign out_and = tree_and(in);
    assign out_or  = tree_or(in);
    assign out_xor = ^in;     // Built-in reduction XOR is optimal

endmodule