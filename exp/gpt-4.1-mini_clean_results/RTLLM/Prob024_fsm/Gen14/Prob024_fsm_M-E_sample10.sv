module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // Shift register to store the last 5 bits of input IN
    reg [4:0] shift_reg;

    always @(posedge CLK or posedge RST) begin
        if (RST)
            shift_reg <= 5'b0;
        else
            // Shift in new input bit from the right (LSB)
            shift_reg <= {shift_reg[3:0], IN};
    end

    // Target sequence 10011 binary: MSB first: 1 0 0 1 1 = 5'b10011
    // MATCH is Mealy output, combinational, asserted when shift_reg matches target
    assign MATCH = (shift_reg == 5'b10011);

endmodule