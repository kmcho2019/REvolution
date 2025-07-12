module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    always @(*) begin
        for (int i = 0; i < 4; i++) begin
            // out_both
            if (i < 3) begin
                out_both[i] = in[i] & in[i+1];
            end else begin
                out_both[i] = 1'b0;
            end

            // out_any
            if (i > 0) begin
                out_any[i] = in[i] | in[i-1];
            end else begin
                out_any[i] = in[i];
            end

            // out_different
            if (i < 3) begin
                out_different[i] = in[i] ^ in[i+1];
            end else begin
                out_different[i] = in[i] ^ in[0]; // Wrap-around
            end
        end
    end

endmodule