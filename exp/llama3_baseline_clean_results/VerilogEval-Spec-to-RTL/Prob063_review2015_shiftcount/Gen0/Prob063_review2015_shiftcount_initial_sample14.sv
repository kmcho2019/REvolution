module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;

always @ (posedge clk) begin
    if (shift_ena) begin
        // Shift in new data from the input 'data'
        q_reg <= {data, q_reg[3:1]};
    end else if (count_ena) begin
        // Decrement the current value in the register
        if (q_reg == 0) begin
            q_reg <= 4'b0000;  // If the register is already 0, don't decrement further
        end else begin
            q_reg <= q_reg - 1;
        end
    end
end

assign q = q_reg;

endmodule