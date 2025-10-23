module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    reg [4:0] shift_reg;

    always @(posedge CLK) begin
        if (RST) begin
            shift_reg <= 5'b0;
            MATCH <= 1'b0;
        end else begin
            // Shift in the new input bit
            shift_reg <= {shift_reg[3:0], IN};
            // Detect pattern 10011 in shift register
            // shift_reg[4:0] holds last 5 bits: oldest at MSB, newest at LSB
            // So pattern: bit4=1, bit3=0, bit2=0, bit1=1, bit0=1
            MATCH <= (shift_reg == 5'b10011);
        end
    end

endmodule