module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both calculation using shift register and bitwise AND
    reg [99:0] in_shifted_left;
    always @(*) begin
        in_shifted_left = {1'b0, in[99:1]};
        for (int i = 0; i < 100; i++) begin
            if (i == 99) begin
                out_both[i] = 1'b0; // out_both[99] is always 0
            end else begin
                out_both[i] = in[i] & in_shifted_left[i];
            end
        end
    end

    // out_any calculation using shift register and bitwise OR
    reg [99:0] in_shifted_right;
    always @(*) begin
        in_shifted_right = {in[98:0], 1'b0};
        for (int i = 0; i < 100; i++) begin
            if (i == 0) begin
                out_any[i] = 1'b0; // out_any[0] is always 0
            end else begin
                out_any[i] = in[i] | in_shifted_right[i];
            end
        end
    end

    // out_different calculation using shift register and bitwise XOR
    reg [99:0] in_shifted_left_wrap;
    always @(*) begin
        in_shifted_left_wrap = {in[0], in[99:1]};
        for (int i = 0; i < 100; i++) begin
            out_different[i] = in[i] ^ in_shifted_left_wrap[i];
        end
    end

endmodule