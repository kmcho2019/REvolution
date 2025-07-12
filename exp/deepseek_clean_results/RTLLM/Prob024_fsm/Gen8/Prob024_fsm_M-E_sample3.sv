module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// 5-bit shift register to store last 5 inputs
reg [4:0] shift_reg;

// Shift register update logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 5'b0;
    end else begin
        shift_reg <= {shift_reg[3:0], IN};
    end
end

// Pattern matching logic
always @(*) begin
    MATCH = (shift_reg == 5'b10011) ? 1'b1 : 1'b0;
end

endmodule