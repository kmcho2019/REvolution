module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    always @(*) begin
        // Handle out_both
        for (int i = 0; i < 100; i++) begin
            if (i == 99) begin
                out_both[i] = 1'b0;  // no left neighbor for in[99]
            end else begin
                out_both[i] = in[i] && in[i+1];
            end
        end

        // Handle out_any
        for (int i = 0; i < 100; i++) begin
            if (i == 0) begin
                out_any[i] = 1'b0;  // no right neighbor for in[0]
            end else begin
                out_any[i] = in[i] || in[i-1];
            end
        end

        // Handle out_different
        for (int i = 0; i < 100; i++) begin
            if (i == 99) begin
                out_different[i] = in[i] != in[0];  // circular comparison for in[99]
            end else begin
                out_different[i] = in[i] != in[i+1];
            end
        end
    end

endmodule