module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

reg [4:0] shift_reg;

// Shift register implementation
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 5'b0;
    end else begin
        shift_reg <= {shift_reg[3:0], IN};
    end
end

// Parallel pattern matching
assign MATCH = (shift_reg == 5'b10011) && !RST;

endmodule