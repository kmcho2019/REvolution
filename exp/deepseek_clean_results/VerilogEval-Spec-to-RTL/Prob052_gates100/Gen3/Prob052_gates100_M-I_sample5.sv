module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Parameterized tree reduction functions
    function automatic logic tree_and;
        input [99:0] vec;
        integer i;
        begin
            tree_and = 1'b1;
            for (i = 0; i < 100; i = i + 1)
                tree_and = tree_and & vec[i];
        end
    endfunction

    function automatic logic tree_or;
        input [99:0] vec;
        integer i;
        begin
            tree_or = 1'b0;
            for (i = 0; i < 100; i = i + 1)
                tree_or = tree_or | vec[i];
        end
    endfunction

    // Balanced tree implementation for AND and OR
    assign out_and = tree_and(in);
    assign out_or = tree_or(in);

    // XOR still uses reduction operator (optimal for synthesis)
    assign out_xor = ^in;

endmodule