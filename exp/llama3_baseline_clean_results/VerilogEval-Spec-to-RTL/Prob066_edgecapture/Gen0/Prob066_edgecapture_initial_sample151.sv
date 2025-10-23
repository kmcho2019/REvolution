module TopModule(
    input           clk,
    input           reset,
    input   [31:0]  in,
    output  [31:0]  out
);

reg    [31:0]  prev_state;
reg    [31:0]  captured;

always @(posedge clk) begin
    if (reset) begin
        prev_state <= 32'd0;
        captured  <= 32'd0;
    end else begin
        prev_state <= in;
        captured  <= captured | (prev_state & (~in));
    end
end

always @(*) begin
    out = captured;
end

endmodule