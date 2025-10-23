module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

reg [4:0] history;

// Shift register to maintain input history
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        history <= 5'b00000;
    end else begin
        history <= {history[3:0], IN};
    end
end

// Parallel pattern matching
assign MATCH = (history == 5'b10011);

endmodule