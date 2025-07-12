module TopModule (
    input  [7:0] in,
    output       parity
);
    // Recursive function to XOR bits in a balanced binary tree manner
    function automatic logic xor_tree(input [7:0] data);
        if (data.size() == 1)
            xor_tree = data[0];
        else begin
            int half = data.size() / 2;
            logic [7:0] left, right;
            left  = data[7:7 - (half - 1)];             // upper half bits
            right = data[half-1:0];                      // lower half bits
            xor_tree = xor_tree(left) ^ xor_tree(right);
        end
    endfunction

    // Assign parity as XOR of all bits via balanced xor_tree function
    assign parity = xor_tree(in);
endmodule