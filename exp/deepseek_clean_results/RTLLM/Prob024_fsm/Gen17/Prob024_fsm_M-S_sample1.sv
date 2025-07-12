module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

reg [4:0] history;  // Stores last 5 inputs

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        history <= 5'b0;
        MATCH <= 1'b0;
    end else begin
        // Shift in new input
        history <= {history[3:0], IN};
        
        // Check for pattern 10011 (MSB first)
        MATCH <= (history[4:1] == 4'b1001) && (IN == 1'b1);
    end
end

endmodule