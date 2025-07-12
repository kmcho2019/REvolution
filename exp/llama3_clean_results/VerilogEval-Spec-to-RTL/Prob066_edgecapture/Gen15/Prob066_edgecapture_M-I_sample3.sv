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
        out <= out | (~in & prev_in);
        prev_in <= in;
    end
end

endmodule