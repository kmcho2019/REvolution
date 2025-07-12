module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    always @(*) begin
        // Initialize out_both, out_any, and out_different to zero
        out_both = 0;
        out_any = 0;
        out_different = 0;

        // Generate out_both
        for (int i = 0; i < 100; i++) begin
            if (i == 99) begin
                // Since in[99] has no neighbor to the left, set out_both[99] to zero
                out_both[i] = 0;
            end else begin
                // Check if both the current bit and its neighbor to the left are '1'
                out_both[i] = in[i] & in[i + 1];
            end
        end

        // Generate out_any
        for (int i = 0; i < 100; i++) begin
            if (i == 0) begin
                // Since in[0] has no neighbor to the right, set out_any[0] to zero
                out_any[i] = 0;
            end else begin
                // Check if either the current bit or its neighbor to the right is '1'
                out_any[i] = in[i] | in[i - 1];
            end
        end

        // Generate out_different
        for (int i = 0; i < 100; i++) begin
            if (i == 99) begin
                // For the last bit, check if it is different from the first bit (wrap around)
                out_different[i] = in[i] ^ in[0];
            end else begin
                // Check if the current bit is different from its neighbor to the left
                out_different[i] = in[i] ^ in[i + 1];
            end
        end
    end

endmodule