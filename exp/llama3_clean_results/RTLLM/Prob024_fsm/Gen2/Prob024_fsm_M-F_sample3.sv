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
            // Only update MATCH to 1 when the sequence matches
            MATCH <= 1;
        end else if (shift_reg[4:1] == 5'b1001 && IN == 1'b1) begin
            // Keep MATCH at 1 if the sequence is still matching
            MATCH <= 1;
        end else begin
            MATCH <= 0;
        end
    end
end

endmodule