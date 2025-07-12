module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output reg MATCH
);

reg [2:0] shift_reg; // 3-bit shift register

// FSM logic with reset
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 3'b000; // Reset shift register
        MATCH <= 1'b0; // Reset MATCH signal
    end else begin
        shift_reg <= {shift_reg[1:0], IN}; // Shift in new input

        if (shift_reg == 3'b001) begin
            if (IN) begin
                MATCH <= 1'b1; // Set MATCH signal
            end else begin
                MATCH <= 1'b0; // Reset MATCH signal
            end
        end else if (shift_reg == 3'b011) begin
            if (IN) begin
                MATCH <= 1'b1; // Set MATCH signal
            end else begin
                MATCH <= 1'b0; // Reset MATCH signal
            end
        end else begin
            MATCH <= 1'b0; // Reset MATCH signal
        end
    end
end

endmodule