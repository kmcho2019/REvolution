module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    reg [99:0] in_shifted_right;
    reg [99:0] in_shifted_left;
    reg [99:0] in_shifted_right_wrap;

    always @(*) begin
        // Shift input vector one position to the right
        in_shifted_right = {in[98:0], 1'b0};

        // Shift input vector one position to the left
        in_shifted_left = {1'b0, in[99:1]};

        // Shift input vector one position to the right with wrap-around
        in_shifted_right_wrap = {in[98:0], in[99]};

        // Calculate out_both
        out_both = in & in_shifted_right;

        // Calculate out_any
        out_any = in | in_shifted_left;

        // Calculate out_different with wrap-around
        out_different = in ^ in_shifted_right_wrap;
    end

endmodule