module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

// Internal register to hold the state of the shift register-counter
reg [3:0] q_reg;

// Always block to handle the positive edge of the clock
always @(posedge clk) begin
    // Determine the next state based on the control inputs
    if (shift_ena) begin
        // Shift in the new data bit into the most significant bit position
        q_reg <= {data, q_reg[3:1]};
    end else if (count_ena) begin
        // Decrement operation will naturally wrap around when reaching zero
        q_reg <= q_reg - 1;
    end else begin
        // Maintain current state if neither shift_ena nor count_ena is high
        q_reg <= q_reg;
    end
end

// Continuous assignment to output the current state of the internal register
assign q = q_reg;

endmodule