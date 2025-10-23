module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    reg [4:0] shift_reg;

    // Shift register updates on clock edge with synchronous reset
    always @(posedge CLK) begin
        if (RST) begin
            shift_reg <= 5'b0;
        end else begin
            shift_reg <= {shift_reg[3:0], IN};
        end
    end

    // Target pattern is 5'b10011
    // MATCH is asserted when shift_reg equals pattern (i.e. last 5 bits match "10011")
    // Since this is a Mealy style, output MATCH can be combinational from current shift_reg contents and IN
    // Here, since shift_reg holds the previous 4 bits and IN is just shifted in, we compare shift_reg with pattern including IN:
    // Because shift_reg already includes IN (shifted in at clock edge), we simply compare shift_reg with pattern.
    assign MATCH = (shift_reg == 5'b10011);

endmodule