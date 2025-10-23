module fsm (
    input IN,
    input CLK,
    input RST,
    output MATCH
);

reg [4:0] history_reg;

// Shift register implementation
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        history_reg <= 5'b0;
    end else begin
        history_reg <= {history_reg[3:0], IN};
    end
end

// Combinational pattern matching
assign MATCH = (history_reg == 5'b10011) ? 1'b1 : 1'b0;

endmodule