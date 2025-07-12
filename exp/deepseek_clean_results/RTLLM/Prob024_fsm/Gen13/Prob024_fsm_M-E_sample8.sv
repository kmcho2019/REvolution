module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// 5-bit shift register to store input history
reg [4:0] input_history;

// Shift register update logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        input_history <= 5'b00000;
    end else begin
        input_history <= {input_history[3:0], IN};
    end
end

// Pattern detection logic
wire pattern_match = (input_history == 5'b10011);

// Output register
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        MATCH <= 1'b0;
    end else begin
        MATCH <= pattern_match;
    end
end

endmodule