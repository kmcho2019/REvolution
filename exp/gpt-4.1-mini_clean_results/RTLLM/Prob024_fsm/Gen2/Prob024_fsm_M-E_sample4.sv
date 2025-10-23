module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

reg [4:0] shift_reg; // Holds the last 5 bits of IN

always @(posedge CLK) begin
    if (RST) begin
        shift_reg <= 5'b0;
        MATCH <= 1'b0;
    end else begin
        shift_reg <= {shift_reg[3:0], IN}; // Shift left and insert new bit

        // Compare shift_reg to sequence 10011
        // Mealy FSM: MATCH asserted simultaneously when last bit received
        MATCH <= (shift_reg == 5'b10011) ? 1'b1 : 1'b0;
    end
end

endmodule