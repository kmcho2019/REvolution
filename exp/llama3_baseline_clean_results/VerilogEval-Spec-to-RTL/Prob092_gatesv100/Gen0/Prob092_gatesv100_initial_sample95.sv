module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    always @(*) begin
        for (int i = 99; i >= 0; i--) begin
            // generate out_both
            if (i == 99) begin
                out_both[i] = 0;
            end else begin
                out_both[i] = in[i] & in[i+1];
            end

            // generate out_any
            if (i == 0) begin
                out_any[i] = 0;
            end else begin
                out_any[i] = in[i] | in[i-1];
            end

            // generate out_different
            if (i == 99) begin
                out_different[i] = in[i] ^ in[0];
            end else begin
                out_different[i] = in[i] ^ in[i+1];
            end
        end
    end

endmodule