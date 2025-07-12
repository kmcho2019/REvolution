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
        
        // Simplified comparison logic
        MATCH <= (shift_reg[4] == 1 && shift_reg[3] == 0 && shift_reg[2] == 0 && shift_reg[1] == 1 && shift_reg[0] == 1)? 1 : 0;
    end
end

endmodule