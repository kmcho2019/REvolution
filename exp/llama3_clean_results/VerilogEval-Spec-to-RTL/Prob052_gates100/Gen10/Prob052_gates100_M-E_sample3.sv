module TreeModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Define a recursive module for AND operation
    module ANDTree(
        input [99:0] in,
        output out
    );
        if (in == 1'b1) begin
            assign out = 1'b1;
        end else if (in == 100'b0) begin
            assign out = 1'b0;
        end else begin
            wire and_left, and_right;
            ANDTree left(in[49:0], and_left);
            ANDTree right(in[99:50], and_right);
            assign out = and_left & and_right;
        end
    endmodule

    // Define a recursive module for OR operation
    module ORTree(
        input [99:0] in,
        output out
    );
        if (in == 1'b0) begin
            assign out = 1'b0;
        end else if (in == 100'b1) begin
            assign out = 1'b1;
        end else begin
            wire or_left, or_right;
            ORTree left(in[49:0], or_left);
            ORTree right(in[99:50], or_right);
            assign out = or_left | or_right;
        end
    endmodule

    // Define a recursive module for XOR operation
    module XORTree(
        input [99:0] in,
        output out
    );
        if (in == 1'b0) begin
            assign out = 1'b0;
        end else if (in == 1'b1) begin
            assign out = 1'b1;
        end else begin
            wire xor_left, xor_right;
            XORTree left(in[49:0], xor_left);
            XORTree right(in[99:50], xor_right);
            assign out = xor_left ^ xor_right;
        end
    endmodule

    // Instantiate the recursive modules
    wire and_out, or_out, xor_out;
    ANDTree and_tree(in, and_out);
    ORTree or_tree(in, or_out);
    XORTree xor_tree(in, xor_out);

    // Assign the outputs
    assign out_and = and_out;
    assign out_or = or_out;
    assign out_xor = xor_out;

endmodule