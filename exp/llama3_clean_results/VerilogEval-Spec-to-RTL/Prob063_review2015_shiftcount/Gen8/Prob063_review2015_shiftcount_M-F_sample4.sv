module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg = 4'b0000; // Initialize q_reg to 0

always @(posedge clk) begin
    if (count_ena) begin
        if (q_reg > 0) begin
            q_reg <= q_reg - 1;
        end else begin
            q_reg <= 0; // Ensure q_reg remains 0 when decrementing from 0
        end
    end else if (shift_ena) begin
        q_reg <= {data, q_reg[3:1]};
    end else begin
        // Do nothing if neither shift_ena nor count_ena is 1
        q_reg <= q_reg;
    end
end

assign q = q_reg;

endmodule