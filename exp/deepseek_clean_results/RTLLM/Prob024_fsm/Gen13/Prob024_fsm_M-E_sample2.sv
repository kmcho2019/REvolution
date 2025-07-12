module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// 5-bit shift register to track input history
reg [4:0] history;

// Pattern to match (10011)
parameter PATTERN = 5'b10011;

// Edge detection for input changes
reg last_IN;
wire IN_changed = (IN != last_IN);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        history <= 5'b0;
        last_IN <= 1'b0;
        MATCH <= 1'b0;
    end else begin
        last_IN <= IN;
        
        // Shift in new input bit
        history <= {history[3:0], IN};
        
        // Check for match only when input changes
        if (IN_changed) begin
            MATCH <= (history == PATTERN);
        end else begin
            MATCH <= 1'b0;
        end
    end
end

endmodule