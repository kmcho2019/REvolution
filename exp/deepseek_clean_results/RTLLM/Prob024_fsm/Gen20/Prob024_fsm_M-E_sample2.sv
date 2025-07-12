module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// 5-bit shift register to store last 5 inputs
reg [4:0] shift_reg;

// Combinational matching logic
assign MATCH = (shift_reg == 5'b10011) && (IN == 1'b1);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 5'b00000;
    end else begin
        // Shift in new bit and shift out oldest bit
        shift_reg <= {shift_reg[3:0], IN};
    end
end

endmodule