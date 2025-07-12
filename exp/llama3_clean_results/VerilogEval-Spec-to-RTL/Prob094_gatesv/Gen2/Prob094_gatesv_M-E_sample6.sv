module TopModule(
    input  [3:0] in,
    output [2:0] out_both,
    output [2:0] out_any,
    output [3:0] out_different
);

    integer i;

    always @(*) begin
        for (i = 0; i < 3; i++) begin
            // out_both
            out_both[i] = in[i] && in[i + 1];

            // out_any
            if (i == 0) begin
                out_any[i] = in[i];
            end else begin
                out_any[i] = in[i] || in[i - 1];
            end

            // out_different
            if (i == 3) begin
                out_different[i] = in[i] ^ in[0];
            end else begin
                out_different[i] = in[i] ^ in[i + 1];
            end
        end
        // Handle the last bit for out_different
        out_different[3] = in[3] ^ in[0];
    end

endmodule