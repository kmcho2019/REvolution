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
    if (shift_ena) begin
        // Shift in the new data bit into the most significant bit position
        // and shift existing bits to the right
        q_reg <= {data, q_reg[3:1]};
    end else if (count_ena) begin
        // Decrement operation using bitwise operation
        q_reg <= (q_reg == 0)? 0 : q_reg - 1;
    end
    // If neither shift_ena nor count_ena is high, maintain current state
end

// Continuous assignment to output the current state of the internal register
assign q = q_reg;

endmodule