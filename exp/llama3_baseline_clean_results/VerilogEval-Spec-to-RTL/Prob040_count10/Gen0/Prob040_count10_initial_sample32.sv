module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] q_reg = 0;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 4'b0000; // synchronous reset
    end else if (q_reg == 4'b1001) begin // if count is 9, reset to 0
        q_reg <= 4'b0000;
    end else begin
        q_reg <= q_reg + 1; // increment counter
    end
end

assign q = q_reg;

endmodule