module TopModule (
    input           clk,
    input           reset,
    input   [31:0]  in,
    output  [31:0]  out
);

reg [31:0] prev_in;
reg [31:0] out_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out_reg <= 32'd0;
    end else begin
        out_reg <= out_reg | (prev_in & (~in));
    end
    prev_in <= in;
end

assign out = out_reg;

endmodule