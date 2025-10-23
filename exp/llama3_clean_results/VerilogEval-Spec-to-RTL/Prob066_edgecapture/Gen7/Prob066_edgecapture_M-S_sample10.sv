module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out = 32'd0
);

always @(posedge clk) begin
    if (reset) begin
        out <= 32'd0;
    end else begin
        for (int i = 0; i < 32; i++) begin
            if (~in[i] && out[i]) begin
                out[i] <= 1'b1;
            end else if (in[i] && ~out[i]) begin
                out[i] <= 1'b0;
            end
        end
    end
end

endmodule