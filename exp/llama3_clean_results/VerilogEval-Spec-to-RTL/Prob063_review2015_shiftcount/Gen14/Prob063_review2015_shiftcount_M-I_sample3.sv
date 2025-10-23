module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg = 4'b0;

// Always block to handle the shift and count operations
always @(posedge clk) begin
    if (shift_ena) begin
        // Shift in the data from the most significant bit to the least significant bit
        q_reg <= {data, q_reg[3:1]};
    end else if (count_ena) begin
        // Decrement the counter if it is not already zero
        if (q_reg != 4'b0) begin
            q_reg <= q_reg - 1;
        end
    end
end

// Continuous assignment to output the current state of the shift register
assign q = q_reg;

endmodule