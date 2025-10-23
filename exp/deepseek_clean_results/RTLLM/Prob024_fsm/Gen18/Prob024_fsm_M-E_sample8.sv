module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// 5-bit shift register to store input history
reg [4:0] history;

// Pattern to match (10011 = 19 in decimal)
localparam PATTERN = 5'b10011;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        history <= 5'b0;
        MATCH <= 1'b0;
    end else begin
        // Shift in new input
        history <= {history[3:0], IN};
        
        // Match occurs when:
        // 1. Current history matches pattern
        // 2. New input is 1 (last bit of pattern)
        // 3. Previous history[3:0] was 1001 (first 4 bits)
        MATCH <= (history == PATTERN) && IN;
    end
end

endmodule