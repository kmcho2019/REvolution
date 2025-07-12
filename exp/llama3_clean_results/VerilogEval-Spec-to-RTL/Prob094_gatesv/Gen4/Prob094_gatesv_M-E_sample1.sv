module TopModule(
    input  [3:0] in,
    output reg [3:0] out_both,
    output reg [3:0] out_any,
    output reg [3:0] out_different
);

    reg [3:0] in_shifted_right;
    reg [3:0] in_shifted_left;

    always @(*) begin
        // Shift input vector to the right
        in_shifted_right = in >> 1;

        // Shift input vector to the left (with wrap-around)
        in_shifted_left = {in[0], in[3:1]};

        // out_both
        out_both[0] = in[0] & in[1];
        out_both[1] = in[1] & in[2];
        out_both[2] = in[2] & in[3];
        out_both[3] = 1'b0; // Since in[3] has no neighbor to the left

        // out_any
        out_any[0] = 1'b1; // Since in[0] has no neighbor to the right, it's always itself
        out_any[1] = in[1] | in_shifted_right[1];
        out_any[2] = in[2] | in_shifted_right[2];
        out_any[3] = in[3] | in_shifted_right[3];

        // out_different
        out_different[0] = in[0] ^ in_shifted_left[0];
        out_different[1] = in[1] ^ in_shifted_left[1];
        out_different[2] = in[2] ^ in_shifted_left[2];
        out_different[3] = in[3] ^ in_shifted_left[3];
    end

endmodule