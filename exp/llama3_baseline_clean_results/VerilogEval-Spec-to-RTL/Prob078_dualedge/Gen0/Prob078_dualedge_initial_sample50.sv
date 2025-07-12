module TopModule (
    input clk,
    input d,
    output reg q
);

reg q_rising;
reg q_falling;
reg rising_edge;

// detect rising edge
always @(posedge clk) begin
    rising_edge <= 1'b1;
end

always @(negedge clk) begin
    rising_edge <= 1'b0;
end

// rising edge triggered flip-flop
always @(posedge clk) begin
    q_rising <= d;
end

// falling edge triggered flip-flop
always @(negedge clk) begin
    q_falling <= d;
end

// multiplex output
always @(*) begin
    if(rising_edge)
        q <= q_rising;
    else
        q <= q_falling;
end

endmodule