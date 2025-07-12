module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg; // Internal reg for output q

// Initialize the register
initial begin
    q_reg = 4'b0000;
end

// Shift register and counter logic
always @(posedge clk) begin
    if (shift_ena) begin
        // Shift in the new data
        q_reg <= {data, q_reg[3:1]};
    end else if (count_ena && q_reg > 4'b0000) begin
        // Decrement the counter
        q_reg <= q_reg - 1;
    end
end

// Assign the value of q_reg to output q
assign q = q_reg;

endmodule