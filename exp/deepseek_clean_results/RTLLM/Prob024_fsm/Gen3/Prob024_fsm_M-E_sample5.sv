module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output wire MATCH
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

// Pattern detection logic
assign MATCH = (shift_reg == 5'b10011) ? 1'b1 : 1'b0;

endmodule