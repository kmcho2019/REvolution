module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // Shift register to hold last 5 input bits
    reg [4:0] shift_reg;

    // On reset, clear shift register; else shift in new input bit
    always @(posedge CLK) begin
        if (RST)
            shift_reg <= 5'b0;
        else
            shift_reg <= {shift_reg[3:0], IN};
    end

    // Pattern to detect: 1 0 0 1 1
    // MATCH is asserted when shift_reg matches 1 0 0 1  and current IN = 1
    // This reflects Mealy FSM behavior where MATCH is asserted with last bit input

    assign MATCH = (shift_reg[4:1] == 4'b1001) & (IN == 1'b1);

endmodule