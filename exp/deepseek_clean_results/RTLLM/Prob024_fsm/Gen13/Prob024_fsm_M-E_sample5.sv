module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

reg [4:0] history;  // Stores last 5 inputs

always @(posedge CLK) begin
    if (RST) begin
        history <= 5'b0;
        MATCH <= 1'b0;
    end else begin
        // Shift in new input and shift out oldest
        history <= {history[3:0], IN};
        
        // Check for pattern match (10011)
        MATCH <= (history == 5'b10011);
    end
end

endmodule