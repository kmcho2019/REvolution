module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    reg [3:0] out_both_reg;
    reg [3:0] out_any_reg;
    reg [3:0] out_different_reg;

    always @(*) begin
        // Initialize output vectors
        out_both_reg = 4'b0000;
        out_any_reg = 4'b0000;
        out_different_reg = 4'b0000;

        // Compute out_both
        for (int i = 0; i < 4; i++) begin
            if (i < 3) begin
                out_both_reg[i] = in[i] & in[i+1];
            end else begin
                out_both_reg[i] = 1'b0; // Since in[3] has no neighbor to the left
            end
        end

        // Compute out_any
        for (int i = 0; i < 4; i++) begin
            if (i > 0) begin
                out_any_reg[i] = in[i] | in[i-1];
            end else begin
                out_any_reg[i] = in[i]; // Since in[0] has no neighbor to the right
            end
        end

        // Compute out_different
        for (int i = 0; i < 4; i++) begin
            if (i == 0) begin
                out_different_reg[i] = in[i] ^ in[3]; // Wrap-around for the first bit
            end else begin
                out_different_reg[i] = in[i] ^ in[i-1];
            end
        end
    end

    assign out_both = out_both_reg;
    assign out_any = out_any_reg;
    assign out_different = out_different_reg;

endmodule