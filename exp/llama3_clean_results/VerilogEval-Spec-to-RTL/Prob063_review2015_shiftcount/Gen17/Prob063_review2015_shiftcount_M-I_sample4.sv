module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;

always @(posedge clk) begin
    if (shift_ena) begin
        // Perform a right shift operation when shift_ena is 1, only update if new data is different
        if (data!= q_reg[0]) begin
            q_reg <= {q_reg[2:0], data};
        end
    end else if (count_ena) begin
        // Decrement the counter when count_ena is 1
        // For simplicity and given the satisfactory synthesis results, we'll stick with the subtraction
        q_reg <= q_reg - 1;
    end
end

assign q = q_reg;

endmodule