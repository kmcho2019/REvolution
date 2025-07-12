module fsm (
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [4:0] shift_reg;  // Stores last 5 inputs

always @(posedge CLK) begin
    if (RST) begin
        shift_reg <= 5'b0;
        MATCH <= 1'b0;
    end else begin
        // Shift in new input
        shift_reg <= {shift_reg[3:0], IN};
        
        // Check for pattern match (10011)
        MATCH <= (shift_reg == 5'b10011);
    end
end

endmodule