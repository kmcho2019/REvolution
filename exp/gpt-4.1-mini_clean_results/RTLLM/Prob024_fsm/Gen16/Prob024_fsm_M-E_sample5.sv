module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // Shift register to hold last 5 inputs; MSB is the oldest bit
    reg [4:0] shift_reg;

    always @(posedge CLK) begin
        if (RST) begin
            shift_reg <= 5'b0;
            MATCH <= 1'b0;
        end else begin
            // Shift left by 1, insert new input at LSB
            shift_reg <= {shift_reg[3:0], IN};
            // Compare with pattern 10011 (binary 5'b10011)
            // Assert MATCH if equal; Mealy FSM outputs MATCH simultaneously with last '1'
            MATCH <= ( {shift_reg[3:0], IN} == 5'b10011 );
        end
    end

endmodule