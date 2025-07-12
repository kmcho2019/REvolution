module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// 5-bit shift register to store input history
reg [4:0] input_history;

// Shift register update logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        input_history <= 5'b0;
    end else begin
        input_history <= {input_history[3:0], IN};
    end
end

// Parallel pattern matching
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        MATCH <= 1'b0;
    end else begin
        // Match when shift register contains 10011 (19 in decimal)
        MATCH <= (input_history == 5'b10011);
    end
end

endmodule