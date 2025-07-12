module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] q_reg;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 4'b0;
    end else begin
        if (q_reg == 4'b1111) begin
            q_reg <= 4'b0;
        end else begin
            q_reg <= q_reg + 1'b1;
        end
    end
end

assign q = q_reg;

endmodule