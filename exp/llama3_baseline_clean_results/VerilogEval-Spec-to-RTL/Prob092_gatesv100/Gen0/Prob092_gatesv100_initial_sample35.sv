module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    always @(*) begin
        // For out_both, set the last bit to 0
        out_both[99] = 0;

        // For out_any, set the first bit to 0
        out_any[0] = 0;

        // Iterate through the input bits to assign out_both and out_any
        for (int i = 98; i >= 0; i--) begin
            out_both[i] = in[i] && in[i + 1];
            out_any[i + 1] = in[i] || in[i + 1];
        end

        // Iterate through the input bits to assign out_different, wrapping around to in[0] when we reach in[99]
        for (int i = 99; i >= 0; i--) begin
            if (i == 99) begin
                out_different[i] = in[i] != in[0];
            end else begin
                out_different[i] = in[i] != in[i + 1];
            end
        end
    end

endmodule