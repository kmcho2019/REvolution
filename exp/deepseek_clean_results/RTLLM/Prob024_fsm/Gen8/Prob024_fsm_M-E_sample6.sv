module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// 5-bit shift register to store input history
reg [4:0] history;

// Shift register update
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        history <= 5'b0;
    end else begin
        history <= {history[3:0], IN};
    end
end

// Parallel pattern matching (looking for 10011)
assign MATCH = (history == 5'b10011) && !RST;

endmodule