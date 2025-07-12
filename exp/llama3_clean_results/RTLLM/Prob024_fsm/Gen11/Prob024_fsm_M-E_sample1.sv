module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [4:0] shift_reg; // 5-bit shift register

// Sequential logic for shift register update
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        shift_reg <= 5'b00000; // Reset shift register
        MATCH <= 1'b0; // Reset MATCH output
    end else begin
        shift_reg <= {shift_reg[3:0], IN}; // Shift in new bit
        if(shift_reg == 5'b10011) begin
            MATCH <= 1'b1; // Set MATCH to 1 if sequence matches
        end else begin
            MATCH <= 1'b0; // Reset MATCH otherwise
        end
    end
end

endmodule