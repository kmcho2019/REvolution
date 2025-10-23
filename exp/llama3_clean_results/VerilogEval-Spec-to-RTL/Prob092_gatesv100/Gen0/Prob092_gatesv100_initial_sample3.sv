module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    reg [99:0] out_both_reg;
    reg [99:0] out_any_reg;
    reg [99:0] out_different_reg;

    always @(*) begin
        // out_both
        out_both_reg[99] = 1'b0;
        for (int i = 98; i >= 0; i--) begin
            out_both_reg[i] = in[i] && in[i+1];
        end

        // out_any
        out_any_reg[0] = 1'b0;
        for (int i = 1; i <= 99; i++) begin
            out_any_reg[i] = in[i] || in[i-1];
        end

        // out_different
        for (int i = 98; i >= 0; i--) begin
            out_different_reg[i] = in[i] !== in[i+1];
        end
        out_different_reg[99] = in[99] !== in[0];

        out_both <= out_both_reg;
        out_any <= out_any_reg;
        out_different <= out_different_reg;
    end

endmodule