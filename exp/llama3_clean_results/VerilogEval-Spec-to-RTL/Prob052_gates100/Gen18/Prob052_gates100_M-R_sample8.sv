module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Calculate the number of levels required for the tree structure
    localparam LEVELS = $clog2(WIDTH);

    // Define a recursive module to create the tree structure
    module TreeOperation #(
        parameter WIDTH = 2
    ) (
        input  [WIDTH-1:0] in,
        output and_out,
        output or_out,
        output xor_out
    );

        // Base case: Handle a single level of the tree
        if (WIDTH == 2) begin
            assign and_out = in[0] & in[1];
            assign or_out  = in[0] | in[1];
            assign xor_out = in[0] ^ in[1];
        end else begin
            // Recursive case: Create a new level in the tree
            wire [WIDTH/2-1:0] and_in, or_in, xor_in;
            wire and_out_tmp, or_out_tmp, xor_out_tmp;

            // Split the input into two halves
            for (genvar i = 0; i < WIDTH/2; i++) begin
                assign and_in[i] = in[i] & in[i + WIDTH/2];
                assign or_in[i]  = in[i] | in[i + WIDTH/2];
                assign xor_in[i] = in[i] ^ in[i + WIDTH/2];
            end

            // Recursively create the next level in the tree
            TreeOperation #(.WIDTH(WIDTH/2)) next_level(
                .in({and_in, or_in, xor_in}),
                .and_out(and_out_tmp),
                .or_out(or_out_tmp),
                .xor_out(xor_out_tmp)
            );

            // Combine the results from the current level
            assign and_out = and_out_tmp;
            assign or_out  = or_out_tmp;
            assign xor_out = xor_out_tmp;
        end

    endmodule

    // Instantiate the recursive module to create the tree structure
    TreeOperation #(.WIDTH(WIDTH)) tree(
        .in(in),
        .and_out(out_and),
        .or_out(out_or),
        .xor_out(out_xor)
    );

endmodule