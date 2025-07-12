module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

reg [4:0] shift_reg;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 5'b0;
        MATCH <= 1'b0;
    end else begin
        // Shift in new input bit
        shift_reg <= {shift_reg[3:0], IN};

        // Check if shifted register matches "10011"
        // Pattern: bit4=1, bit3=0, bit2=0, bit1=1, bit0=1
        if (shift_reg == 5'b10011)
            MATCH <= 1'b1;
        else
            MATCH <= 1'b0;
    end
end

endmodule