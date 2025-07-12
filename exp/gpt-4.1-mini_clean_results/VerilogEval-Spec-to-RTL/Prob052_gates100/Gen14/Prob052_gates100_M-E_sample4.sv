module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Parameter for group size at each stage of reduction
    // 4 chosen for a balanced tradeoff between logic depth and gate fan-in
    localparam GROUP_SIZE = 4;

    // Calculate how many groups needed at each level given input width
    function integer group_count;
        input integer width;
        input integer group_size;
        begin
            group_count = (width + group_size - 1) / group_size; // ceil division
        end
    endfunction

    // Recursive function to generate reduction tree for a signal vector
    // Returns a single bit wire representing the final reduction
    // reduction_op: 0=AND, 1=OR, 2=XOR
    function automatic [0:0] reduce_tree;
        input integer reduction_op;
        input integer width;
        input [width-1:0] data;
        integer i, groups;
        reg [group_count(width, GROUP_SIZE)-1:0] partial_results;
        reg [GROUP_SIZE-1:0] slice;
        begin
            if (width == 1) begin
                reduce_tree = data[0];
            end else begin
                groups = group_count(width, GROUP_SIZE);
                // Compute partial results for each group
                for (i = 0; i < groups; i = i + 1) begin
                    // Extract slice, pad with zeros if beyond width
                    integer j;
                    for (j = 0; j < GROUP_SIZE; j = j + 1) begin
                        if (i*GROUP_SIZE + j < width)
                            slice[j] = data[i*GROUP_SIZE + j];
                        else
                            slice[j] = (reduction_op == 1) ? 0 : // OR padding with 0
                                       (reduction_op == 0) ? 1 : // AND padding with 1
                                       0;                      // XOR padding with 0 (neutral element)
                    end
                    // Perform reduction on the slice using built-in reduction operators
                    case (reduction_op)
                        0: partial_results[i] = &slice; // AND
                        1: partial_results[i] = |slice; // OR
                        2: partial_results[i] = ^slice; // XOR
                        default: partial_results[i] = 1'bx;
                    endcase
                end
                // Recur to reduce partial results further until single bit
                reduce_tree = reduce_tree(reduction_op, groups, partial_results);
            end
        end
    endfunction

    // Compute each output by invoking the reduction tree function
    assign out_and = reduce_tree(0, 100, in);
    assign out_or  = reduce_tree(1, 100, in);
    assign out_xor = reduce_tree(2, 100, in);

endmodule