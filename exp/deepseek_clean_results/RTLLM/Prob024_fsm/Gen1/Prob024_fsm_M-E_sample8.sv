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

// Pattern matching logic
always @(*) begin
    // Match when last 5 bits are 10011 and current input is 1
    // Note: Current IN is already shifted into shift_reg[0] by this point
    MATCH = (shift_reg == 5'b10011) ? 1'b1 : 1'b0;
end

endmodule