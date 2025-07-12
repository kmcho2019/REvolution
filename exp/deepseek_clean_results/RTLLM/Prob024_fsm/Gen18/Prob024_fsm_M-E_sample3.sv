module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// Target pattern: 10011 (MSB first)
localparam [4:0] PATTERN = 5'b10011;

// 5-bit shift register
reg [4:0] shift_reg;

// Shift register update
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 5'b0;
        MATCH <= 1'b0;
    end else begin
        // Shift in new bit at LSB
        shift_reg <= {shift_reg[3:0], IN};
        
        // Check for pattern match
        MATCH <= (shift_reg == PATTERN);
    end
end

endmodule