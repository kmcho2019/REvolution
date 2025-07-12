module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;

always_ff @(posedge clk) begin
    if (shift_ena) begin
        q_reg <= {data, q_reg[3:1]};
    end else if (count_ena) begin
        if (q_reg == 4'b0000) begin
            q_reg <= 4'b0000; // handle underflow
        end else begin
            q_reg <= q_reg - 1'b1;
        end
    end
end

assign q = q_reg;

endmodule