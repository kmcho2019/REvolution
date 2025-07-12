module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// 5-bit shift register to store input history
reg [4:0] history_reg;

// Shift register update logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        history_reg <= 5'b0;
    end else begin
        history_reg <= {history_reg[3:0], IN};
    end
end

// Parallel pattern matching
assign MATCH = (history_reg == 5'b10011) && !RST;

endmodule