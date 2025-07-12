module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_rising, q_falling;

// Flip-flop for rising edge
always @(posedge clk)
    q_rising <= d;

// Flip-flop for falling edge
always @(negedge clk)
    q_falling <= d;

// Combine the outputs based on the clock edge
always @(posedge clk or negedge clk)
    if (clk)
        q <= q_rising;
    else
        q <= q_falling;

endmodule