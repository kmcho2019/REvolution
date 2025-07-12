module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

reg [4:0] shift_reg;

// Shift register implementation
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 5'b00000;
    end else begin
        shift_reg <= {shift_reg[3:0], IN};  // Shift left and insert new bit
    end
end

// Pattern matching logic (combinational)
assign MATCH = (shift_reg == 5'b10011);  // Direct pattern comparison

endmodule