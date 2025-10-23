module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out
);

reg [31:0] out_reg;

always @(posedge clk) begin
    if (reset) begin
        out_reg <= 32'd0;
    end else begin
        for (int i = 0; i < 32; i++) begin
            if (in[i] && !out_reg[i]) begin
                // Do nothing if in[i] is 1 and out_reg[i] is 0
            end else if (!in[i] && out_reg[i]) begin
                // Do nothing if in[i] is 0 and out_reg[i] is 1
            end else if (in[i] == 1'b0 && out_reg[i] == 1'b0) begin
                // Check if in[i] was previously 1 and now is 0
                if (i > 0 && in[i-1] == 1'b1 && out_reg[i-1] == 1'b1) begin
                    // No change
                end else begin
                    out_reg[i] <= 1'b1;
                end
            end else begin
                // No change
            end
        end
    end
    out <= out_reg;
end

endmodule