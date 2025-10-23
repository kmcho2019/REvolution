module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

// Internal register to hold the state of the shift register-counter
reg [3:0] q_reg;

// Look-up table for decrement operation
reg [3:0] dec_table [15:0];

// Initialize look-up table for decrement operation
initial begin
    for (int i = 0; i < 16; i++) begin
        dec_table[i] = i - 1;
    end
end

// Always block to handle the positive edge of the clock
always @(posedge clk) begin
    if (shift_ena) begin
        // Shift in the new data bit into the most significant bit position
        // and shift existing bits to the right (most-significant-bit first)
        q_reg <= {data, q_reg[3:1]};
    end else if (count_ena) begin
        // Decrement operation using the look-up table
        q_reg <= dec_table[q_reg];
    end
    // If neither shift_ena nor count_ena is high, maintain current state
end

// Continuous assignment to output the current state of the internal register
assign q = q_reg;

endmodule