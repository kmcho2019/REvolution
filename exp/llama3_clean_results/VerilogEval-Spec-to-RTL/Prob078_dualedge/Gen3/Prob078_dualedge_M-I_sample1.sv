module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_rising; // Flip-flop triggered on rising edge
reg q_falling; // Flip-flop triggered on falling edge

// Rising edge flip-flop
always @(posedge clk)
    q_rising <= d;

// Falling edge flip-flop
always @(negedge clk)
    q_falling <= d;

// Output multiplexer
always @(posedge clk or negedge clk)
    if (clk)
        q <= q_rising;
    else
        q <= q_falling;

endmodule