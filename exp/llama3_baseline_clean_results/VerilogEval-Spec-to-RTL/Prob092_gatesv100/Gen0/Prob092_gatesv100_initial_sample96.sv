module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Initialize output vectors
    always @(in) begin
        out_both = 100'b0;
        out_any = 100'b0;
        out_different = 100'b0;

        // Calculate out_both
        for (int i = 99; i >= 0; i--) begin
            if (i == 99) begin
                out_both[i] = 1'b0; // No neighbor to the left
            end else begin
                out_both[i] = in[i] && in[i + 1];
            end
        end

        // Calculate out_any
        for (int i = 0; i <= 99; i++) begin
            if (i == 0) begin
                out_any[i] = 1'b0; // No neighbor to the right
            end else begin
                out_any[i] = in[i] || in[i - 1];
            end
        end

        // Calculate out_different
        for (int i = 0; i <= 99; i++) begin
            if (i == 0) begin
                out_different[i] = in[i]!= in[99]; // Wrap around
            end else begin
                out_different[i] = in[i]!= in[i - 1];
            end
        end
    end

endmodule