module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;
wire [3:0] next_state;

// Combinational logic to determine the next state
always @(*) begin
    if (shift_ena) begin
        // Shift in the new data bit into the most significant bit position
        next_state = {data, q_reg[3:1]};
    end else if (count_ena) begin
        // Decrement operation will naturally wrap around when reaching zero
        next_state = q_reg - 1;
    end else begin
        // If neither shift_ena nor count_ena is high, maintain current state
        next_state = q_reg;
    end
end

// Sequential logic to update the register on the positive edge of the clock
always @(posedge clk) begin
    q_reg <= next_state;
end

// Continuous assignment to output the current state of the internal register
assign q = q_reg;

endmodule