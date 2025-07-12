module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

reg [4:0] shift_reg;  // 5-bit shift register to store last 5 inputs

// Shift register update logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 5'b0;
    end else begin
        shift_reg <= {shift_reg[3:0], IN};  // Shift left and insert new bit
    end
end

// Pattern matching - combinatorial output
assign MATCH = (shift_reg == 5'b10011) && !RST;

endmodule