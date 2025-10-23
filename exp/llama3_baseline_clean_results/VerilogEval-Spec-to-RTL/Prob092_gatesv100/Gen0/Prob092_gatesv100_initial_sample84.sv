module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    always @(*) begin
        // Initialize out_both, out_any, and out_different
        out_both = 0;
        out_any = 0;
        out_different = 0;

        // Generate out_both
        for (int i = 0; i < 100; i++) begin
            if (i == 99) begin
                out_both[i] = 0;
            end else begin
                out_both[i] = in[i] & in[i+1];
            end
        end

        // Generate out_any
        for (int i = 0; i < 100; i++) begin
            if (i == 0) begin
                out_any[i] = 0;
            end else begin
                out_any[i] = in[i] | in[i-1];
            end
        end

        // Generate out_different
        for (int i = 0; i < 100; i++) begin
            if (i == 99) begin
                out_different[i] = in[i] ^ in[0];
            end else begin
                out_different[i] = in[i] ^ in[i+1];
            end
        end
    end

endmodule