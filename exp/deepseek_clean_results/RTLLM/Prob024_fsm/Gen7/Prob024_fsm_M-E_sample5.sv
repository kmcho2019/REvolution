module fsm (
    input wire CLK,
    input wire RST,
    input wire IN,
    output reg MATCH
);

// 5-bit shift register to store input history
reg [4:0] history;

// Pattern to detect (10011)
localparam [4:0] PATTERN = 5'b10011;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        history <= 5'b0;
        MATCH <= 1'b0;
    end
    else begin
        // Shift in new input
        history <= {history[3:0], IN};
        
        // Check for pattern match
        MATCH <= (history == PATTERN);
    end
end

endmodule