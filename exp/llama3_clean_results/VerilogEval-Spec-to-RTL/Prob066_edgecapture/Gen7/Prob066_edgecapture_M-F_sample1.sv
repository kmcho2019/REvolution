module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out = 32'd0
);

reg [31:0] prev_in = 32'd0;

always @(posedge clk) begin
    if (reset) begin
        out <= 32'd0;
        prev_in <= 32'd0;
    end else begin
        prev_in <= in;
        for (int i = 0; i < 32; i++) begin
            if (~in[i] && prev_in[i]) begin
                out[i] <= 1'b1;
            end else if (out[i]) begin
                out[i] <= 1'b1; // retain previous value if already set
            end else begin
                out[i] <= 1'b0; // reset if not previously set and no transition
            end
        end
    end
end

endmodule