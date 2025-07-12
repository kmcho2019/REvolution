module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output wire MATCH
);

// 5-bit shift register to store input history
reg [4:0] history;

always @(posedge CLK or posedge RST) begin
    if (RST)
        history <= 5'b0;
    else
        history <= {history[3:0], IN};
end

// Pattern matching logic (10011)
// Mealy output: current input must be 1 when pattern matches
assign MATCH = (history == 5'b10011) && IN;

endmodule