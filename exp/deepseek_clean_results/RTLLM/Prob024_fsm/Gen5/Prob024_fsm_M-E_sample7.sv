module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// 5-bit shift register to store input history
reg [4:0] history;

// Shift register operation
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        history <= 5'b0;
        MATCH <= 1'b0;
    end else begin
        // Shift in new bit and compare
        history <= {history[3:0], IN};
        MATCH <= ({history[3:0], IN} == 5'b10011);
    end
end

endmodule