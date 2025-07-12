module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

reg [4:0] shift_reg;  // 5-bit shift register for pattern storage
wire pattern_match = (shift_reg == 5'b10011);  // Parallel comparison

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 5'b0;
        MATCH <= 1'b0;
    end else begin
        // Shift in new bit and shift out oldest bit
        shift_reg <= {shift_reg[3:0], IN};
        
        // Edge detection: only assert MATCH when pattern first appears
        MATCH <= pattern_match && !({shift_reg[3:0], IN} == 5'b10011);
    end
end

endmodule