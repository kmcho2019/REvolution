module TopModule(
    input  clk,
    input  reset,
    output [9:0] q
);

reg [9:0] q_reg;

always @ (posedge clk) begin
    if (reset) begin
        q_reg <= 10'd0;
    end else if (q_reg == 10'd999) begin
        q_reg <= 10'd0;
    end else begin
        q_reg <= q_reg + 10'd1;
    end
end

assign q = q_reg;

endmodule