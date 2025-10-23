module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [4:0] shift_reg;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 5'b00000;
        MATCH <= 0;
    end else begin
        shift_reg <= {shift_reg[3:0], IN};
        if (shift_reg == 5'b10011) begin
            // Correctly update MATCH to 1 when the sequence matches
            MATCH <= 1;
        end else if (shift_reg[4:1] == 5'b10011 && IN == 1'b0) begin
            // Handle the case where the sequence is 10011 and the next input is 0
            MATCH <= 0;
        end else if (shift_reg[3:0] == 4'b0011 && IN == 1'b1) begin
            // Keep MATCH at 1 if the sequence extends or repeats
            MATCH <= 1;
        end else begin
            // Default case: set MATCH to 0 for non-matching sequences
            MATCH <= 0;
        end
    end
end

endmodule