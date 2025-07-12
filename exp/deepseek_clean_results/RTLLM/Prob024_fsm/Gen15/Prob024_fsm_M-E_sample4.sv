module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// 5-bit shift register to store input sequence
reg [4:0] shift_reg;

// Pattern to match (10011)
parameter PATTERN = 5'b10011;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 5'b0;
        MATCH <= 1'b0;
    end else begin
        // Shift in new bit and shift out oldest bit
        shift_reg <= {shift_reg[3:0], IN};
        
        // Check for pattern match
        MATCH <= (shift_reg == PATTERN);
    end
end

endmodule