module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    reg [99:0] in_shifted_right;
    reg [99:0] in_shifted_left;

    always @(*) begin
        // Shift input vector one position to the right
        in_shifted_right = {in[98:0], 1'b0};

        // Shift input vector one position to the left with wrap-around
        in_shifted_left = {in[1], in[99:1]};

        // Compute output vectors
        out_both = in & in_shifted_right;
        out_any = in | in_shifted_left;
        out_different = in ^ in_shifted_left;
    end

endmodule