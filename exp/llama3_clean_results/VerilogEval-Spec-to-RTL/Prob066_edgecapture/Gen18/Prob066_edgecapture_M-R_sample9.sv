module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out
);

reg [31:0] in_prev;
reg [31:0] out_reg;

always @(posedge clk) begin
    if (reset) begin
        in_prev <= 32'd0;
        out_reg <= 32'd0;
    end else begin
        in_prev <= in;
        for (int i = 0; i < 32; i++) begin
            if (in_prev[i] == 1 && in[i] == 0) begin
                out_reg[i] <= 1'b1;
            end
        end
    end
end

assign out = out_reg;

endmodule