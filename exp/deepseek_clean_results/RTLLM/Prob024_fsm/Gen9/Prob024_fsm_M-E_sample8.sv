module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// 5-bit shift register to store last 5 inputs
reg [4:0] shift_reg;

// Target pattern to detect: 10011 (MSB first)
parameter PATTERN = 5'b10011;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 5'b0;
        MATCH <= 1'b0;
    end else begin
        // Shift in new bit and shift out oldest
        shift_reg <= {shift_reg[3:0], IN};
        
        // Compare with target pattern
        MATCH <= (shift_reg == PATTERN);
    end
end

endmodule