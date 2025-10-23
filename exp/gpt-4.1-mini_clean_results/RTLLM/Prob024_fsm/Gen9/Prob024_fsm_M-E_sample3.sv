module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    reg [4:0] shift_reg;

    // Shift register logic with synchronous reset
    always @(posedge CLK or posedge RST) begin
        if (RST)
            shift_reg <= 5'b00000;
        else
            shift_reg <= {shift_reg[3:0], IN};
    end

    // MATCH output: 1 if shift_reg matches pattern 10011
    assign MATCH = (shift_reg == 5'b10011);

endmodule