module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out = 32'd0
);

reg [31:0] prev_in = 32'd0;

always @(posedge clk) begin
    if (reset) begin
        prev_in <= 32'd0;
        out <= 32'd0;
    end else begin
        prev_in <= in;
        for (int i = 0; i < 32; i++) begin
            if (~in[i] & prev_in[i]) begin
                out[i] <= 1'b1;
            end else if (out[i] == 1'b1) begin
                // Keep the output bit high if it was previously set
                out[i] <= 1'b1;
            end else begin
                // If no transition detected and bit wasn't previously set, keep it low
                out[i] <= 1'b0;
            end
        end
    end
end

endmodule