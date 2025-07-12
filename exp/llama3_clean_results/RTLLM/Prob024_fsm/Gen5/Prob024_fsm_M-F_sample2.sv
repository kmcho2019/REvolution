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
        if (IN) begin // Update shift register only when IN is 1
            shift_reg <= {shift_reg[3:0], IN};
            if (shift_reg == 5'b10011) begin
                MATCH <= 1;
            end else begin
                MATCH <= 0;
            end
        end else if (shift_reg != 5'b00000) begin // Update shift register when IN is 0 and shift register is not empty
            shift_reg <= {shift_reg[3:0], IN};
            MATCH <= 0;
        end
    end
end

endmodule