module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [3:0] shift_reg;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 4'b0000;
        MATCH <= 0;
    end else begin
        shift_reg <= {shift_reg[2:0], IN};
        MATCH <= (shift_reg == 4'b10011)? 1 : 0;
    end
end

endmodule