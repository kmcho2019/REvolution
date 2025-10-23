module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg = 4'b0000;

assign q = q_reg;

always @(posedge clk) begin
    if (shift_ena) begin
        q_reg <= {data, q_reg[3:1]};
    end else if (count_ena) begin
        if (q_reg == 4'b0000) begin
            q_reg <= 4'b0000; // Prevents counting below 0
        end else begin
            q_reg <= q_reg - 1;
        end
    end else begin
        q_reg <= q_reg; // No change when neither shift_ena nor count_ena is high
    end
end

endmodule