module fsm (
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// 5-bit shift register to store last 5 inputs
reg [4:0] pattern_reg;

// Shift register update logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        pattern_reg <= 5'b0;
    end else begin
        pattern_reg <= {pattern_reg[3:0], IN};
    end
end

// Pattern matching logic (10011)
always @(*) begin
    if (pattern_reg == 5'b10011 && IN == 1'b1) begin
        MATCH = 1'b1;
    end else begin
        MATCH = 1'b0;
    end
end

endmodule