module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Tree-based AND implementation
    function automatic logic tree_and(input [99:0] vec);
        if (vec.size() == 1) begin
            return vec[0];
        end else begin
            int half = vec.size() / 2;
            return tree_and(vec[half-1:0]) & tree_and(vec[vec.size()-1:half]);
        end
    endfunction
    assign out_and = tree_and(in);

    // Tree-based OR implementation
    function automatic logic tree_or(input [99:0] vec);
        if (vec.size() == 1) begin
            return vec[0];
        end else begin
            int half = vec.size() / 2;
            return tree_or(vec[half-1:0]) | tree_or(vec[vec.size()-1:half]);
        end
    endfunction
    assign out_or = tree_or(in);

    // Tree-based XOR implementation
    function automatic logic tree_xor(input [99:0] vec);
        if (vec.size() == 1) begin
            return vec[0];
        end else begin
            int half = vec.size() / 2;
            return tree_xor(vec[half-1:0]) ^ tree_xor(vec[vec.size()-1:half]);
        end
    endfunction
    assign out_xor = tree_xor(in);

endmodule