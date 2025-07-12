module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// 5-bit shift register to store last 5 inputs
reg [4:0] shift_reg;

// Shift register update logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 5'b0;
    end else begin
        shift_reg <= {shift_reg[3:0], IN};
    end
end

// Pattern matching logic (10011)
always @(*) begin
    // Match occurs when shift register contains 10011
    // and we're on the last bit of the pattern (current IN is 1)
    MATCH = (shift_reg == 5'b10011) && IN;
end

endmodule