module TopModule (
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Internal function to compute tree reduction for AND
    function automatic logic tree_and(input logic [99:0] data, input int len);
        if (len == 1)
            tree_and = data[0];
        else begin
            int half = (len + 1) / 2;
            logic [half-1:0] left_part;
            logic [len-half-1:0] right_part;
            int i;
            // Assign left half
            for (i = 0; i < half; i = i + 1)
                left_part[i] = data[i];
            // Assign right half
            for (i = 0; i < len - half; i = i + 1)
                right_part[i] = data[i + half];
            tree_and = tree_and(left_part, half) & tree_and(right_part, len - half);
        end
    endfunction

    // Internal function to compute tree reduction for OR
    function automatic logic tree_or(input logic [99:0] data, input int len);
        if (len == 1)
            tree_or = data[0];
        else begin
            int half = (len + 1) / 2;
            logic [half-1:0] left_part;
            logic [len-half-1:0] right_part;
            int i;
            for (i = 0; i < half; i = i + 1)
                left_part[i] = data[i];
            for (i = 0; i < len - half; i = i + 1)
                right_part[i] = data[i + half];
            tree_or = tree_or(left_part, half) | tree_or(right_part, len - half);
        end
    endfunction

    // Internal function to compute tree reduction for XOR
    function automatic logic tree_xor(input logic [99:0] data, input int len);
        if (len == 1)
            tree_xor = data[0];
        else begin
            int half = (len + 1) / 2;
            logic [half-1:0] left_part;
            logic [len-half-1:0] right_part;
            int i;
            for (i = 0; i < half; i = i + 1)
                left_part[i] = data[i];
            for (i = 0; i < len - half; i = i + 1)
                right_part[i] = data[i + half];
            tree_xor = tree_xor(left_part, half) ^ tree_xor(right_part, len - half);
        end
    endfunction

    assign out_and = tree_and(in, 100);
    assign out_or  = tree_or(in, 100);
    assign out_xor = tree_xor(in, 100);

endmodule