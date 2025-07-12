module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// 5-bit history buffer (shift register)
reg [4:0] history;

// Continuous pattern matching
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        history <= 5'b0;
        MATCH <= 1'b0;
    end else begin
        // Shift in new bit and maintain last 4 bits
        history <= {history[3:0], IN};
        
        // Direct parallel comparison with target pattern
        MATCH <= (history == 5'b10011);
    end
end

endmodule