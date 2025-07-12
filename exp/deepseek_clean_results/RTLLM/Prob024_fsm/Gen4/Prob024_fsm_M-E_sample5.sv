module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

reg [4:0] history;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        history <= 5'b0;
        MATCH <= 1'b0;
    end
    else begin
        // Shift in new input
        history <= {history[3:0], IN};
        
        // Check for pattern match when last bit is 1
        MATCH <= (history[3:0] == 4'b1001) && (IN == 1'b1);
    end
end

endmodule