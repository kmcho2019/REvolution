module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // Shift register to hold the last 5 input bits, MSB oldest, LSB newest
    reg [4:0] shift_reg;

    always @(posedge CLK) begin
        if (RST)
            shift_reg <= 5'b0;
        else
            shift_reg <= {shift_reg[3:0], IN}; // shift left, insert IN at LSB
    end

    // Target pattern to detect: 1 0 0 1 1 (MSB to LSB)
    // MATCH asserted when shift_reg equals pattern, indicating detection on last bit arrival (Mealy)
    assign MATCH = (shift_reg == 5'b10011);

endmodule