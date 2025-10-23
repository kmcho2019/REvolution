module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q_reg;

always @ (posedge clk) begin
    if (~a) begin
        if (q_reg == 7) begin
            q_reg <= 0;
        end else begin
            q_reg <= q_reg + 1;
        end
    end else begin
        q_reg <= 4;
    end
end

assign q = q_reg;

initial begin
    q_reg = 4;
end

endmodule