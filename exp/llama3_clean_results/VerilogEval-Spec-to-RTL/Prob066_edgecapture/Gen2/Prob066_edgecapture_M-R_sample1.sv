module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] prev_in;
reg [31:0] out_reg;

always @(posedge clk) begin
    if (reset) begin
        prev_in <= 32'd0;
        out_reg <= 32'd0;
    end else begin
        prev_in <= in;
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] == 1 && in[i] == 0) begin
                out_reg[i] <= 1'b1;
            end else if (out_reg[i] == 1'b1) begin
                // If out_reg[i] is already set, keep it set unless reset
                out_reg[i] <= 1'b1;
            end else begin
                // If no transition and out_reg[i] is 0, keep it 0
                out_reg[i] <= 1'b0;
            end
        end
    end
end

assign out = out_reg;

endmodule