module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    reg [99:0] in_shifted_left;
    reg [99:0] in_shifted_right;
    reg [99:0] out_both_int;
    reg [99:0] out_any_int;
    reg [99:0] out_different_int;

    always @(*) begin
        in_shifted_left = {in[98:0], 1'b0};
        in_shifted_right = {1'b0, in[99:1]};
    end

    always @(*) begin
        for (int i = 0; i < 100; i++) begin
            out_both_int[i] = (i < 99)? (in[i] & in_shifted_left[i]) : 1'b0;
            out_any_int[i] = (i > 0)? (in[i] | in_shifted_right[i]) : 1'b0;
            out_different_int[i] = in[i] ^ ((i == 99)? in[0] : in_shifted_left[i]);
        end
    end

    always @(posedge clk) begin
        out_both <= out_both_int;
        out_any <= out_any_int;
        out_different <= out_different_int;
    end

endmodule