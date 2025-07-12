module TopModule(
    input           clk,
    input           reset,
    input  [31:0]   in,
    output [31:0]   out
);

reg [31:0] prev_in;
reg [31:0] out_reg;

assign out = out_reg;

always @(posedge clk) begin
    if (reset) begin
        out_reg <= 32'd0;
        prev_in <= 32'd0;
    end else begin
        if (prev_in != 0 && (prev_in & (~in)) != 0) begin
            out_reg <= out_reg | (prev_in & (~in));
        end
        prev_in <= in;
    end
end

endmodule