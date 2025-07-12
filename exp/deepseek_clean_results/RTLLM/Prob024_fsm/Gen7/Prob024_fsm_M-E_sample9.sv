module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

reg [4:0] shift_reg;  // 5-bit shift register to store last 5 inputs

always @(posedge CLK) begin
    if (RST) begin
        shift_reg <= 5'b0;
        MATCH <= 1'b0;
    end else begin
        // Shift in new input and shift out oldest bit
        shift_reg <= {shift_reg[3:0], IN};
        
        // Check for pattern match (10011)
        MATCH <= (shift_reg == 5'b10011);
    end
end

endmodule