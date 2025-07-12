module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Calculate next power of 2 >= 100 for tree size
    localparam N = 128; // use 128 for convenience (next power of two)

    // Pad inputs for each reduction function:
    // AND padded with 1, OR padded with 0, XOR padded with 0 (identity)
    wire [N-1:0] and_inputs;
    wire [N-1:0] or_inputs;
    wire [N-1:0] xor_inputs;

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : input_padding
            assign and_inputs[i] = (i < 100) ? in[i] : 1'b1;
            assign or_inputs[i]  = (i < 100) ? in[i] : 1'b0;
            assign xor_inputs[i] = (i < 100) ? in[i] : 1'b0;
        end
    endgenerate

    // Recursive binary reduction trees for AND, OR, XOR
    // Function to build binary tree for AND
    function automatic [0:0] build_and_tree;
        input integer width;
        input wire [N-1:0] data;
        integer half;
        wire [N-1:0] left_data;
        wire [N-1:0] right_data;
        reg [0:0] left_val, right_val;
        integer j;
        begin
            if (width == 1) begin
                build_and_tree = data[0];
            end else begin
                half = width / 2;
                // Left subtree
                reg [N-1:0] left_slice;
                for (j = 0; j < half; j = j + 1)
                    left_slice[j] = data[j];
                left_val = build_and_tree(half, left_slice);
                // Right subtree
                reg [N-1:0] right_slice;
                for (j = 0; j < width - half; j = j + 1)
                    right_slice[j] = data[half + j];
                right_val = build_and_tree(width - half, right_slice);

                build_and_tree = left_val & right_val;
            end
        end
    endfunction

    // Similar functions for OR and XOR are tricky to write in Verilog
    // So instead, build iterative tree modules for each reduction.

    // Define a generic module for a binary tree reduction of 2-input AND gates
    module AndTree #(parameter WIDTH = 1) (
        input  wire [WIDTH-1:0] in,
        output wire             out
    );
        if (WIDTH == 1) begin
            assign out = in[0];
        end else if (WIDTH == 2) begin
            assign out = in[0] & in[1];
        end else begin
            localparam HALF = WIDTH / 2;
            wire left_out, right_out;
            AndTree #(HALF) left_tree (.in(in[HALF-1:0]), .out(left_out));
            AndTree #(WIDTH-HALF) right_tree (.in(in[WIDTH-1:HALF]), .out(right_out));
            assign out = left_out & right_out;
        end
    endmodule

    // Similar module for OR
    module OrTree #(parameter WIDTH = 1) (
        input  wire [WIDTH-1:0] in,
        output wire             out
    );
        if (WIDTH == 1) begin
            assign out = in[0];
        end else if (WIDTH == 2) begin
            assign out = in[0] | in[1];
        end else begin
            localparam HALF = WIDTH / 2;
            wire left_out, right_out;
            OrTree #(HALF) left_tree (.in(in[HALF-1:0]), .out(left_out));
            OrTree #(WIDTH-HALF) right_tree (.in(in[WIDTH-1:HALF]), .out(right_out));
            assign out = left_out | right_out;
        end
    endmodule

    // Similar module for XOR (parity)
    module XorTree #(parameter WIDTH = 1) (
        input  wire [WIDTH-1:0] in,
        output wire             out
    );
        if (WIDTH == 1) begin
            assign out = in[0];
        end else if (WIDTH == 2) begin
            assign out = in[0] ^ in[1];
        end else begin
            localparam HALF = WIDTH / 2;
            wire left_out, right_out;
            XorTree #(HALF) left_tree (.in(in[HALF-1:0]), .out(left_out));
            XorTree #(WIDTH-HALF) right_tree (.in(in[WIDTH-1:HALF]), .out(right_out));
            assign out = left_out ^ right_out;
        end
    endmodule

    // Instantiate each tree for 128 inputs
    wire and_tree_out, or_tree_out, xor_tree_out;

    AndTree #(N) and_tree (.in(and_inputs), .out(and_tree_out));
    OrTree  #(N) or_tree  (.in(or_inputs),  .out(or_tree_out));
    XorTree #(N) xor_tree (.in(xor_inputs), .out(xor_tree_out));

    // Final outputs
    assign out_and = and_tree_out;
    assign out_or  = or_tree_out;
    assign out_xor = xor_tree_out;

endmodule