module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] q_reg;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 4'b0001;
    end else if (q_reg == 4'b1010) begin
        q_reg <= 4'b0001;
    end else begin
        q_reg <= q_reg + 1;
    end
end

assign q = q_reg;

endmodule