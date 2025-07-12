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
        // Initialize all output bits to 0
        out_both_reg = 4'b0000;
        out_any_reg = 4'b0000;
        out_different_reg = 4'b0000;

        // out_both
        for (int i = 0; i < 3; i++) begin
            out_both_reg[i] = in[i] & in[i+1];
        end

        // out_any
        for (int i = 1; i < 4; i++) begin
            out_any_reg[i] = in[i] | in[i-1];
        end

        // out_different
        for (int i = 0; i < 4; i++) begin
            if (i == 3) begin
                out_different_reg[i] = in[i] ^ in[0];
            end else begin
                out_different_reg[i] = in[i] ^ in[i+1];
            end
        end
    end

    assign out_both = out_both_reg;
    assign out_any = out_any_reg;
    assign out_different = out_different_reg;

endmodule