module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_rising;  // output of rising edge flip-flop
reg q_falling; // output of falling edge flip-flop

// rising edge flip-flop
always @(posedge clk)
    q_rising <= d;

// falling edge flip-flop
always @(negedge clk)
    q_falling <= d;

// multiplexer to select output based on clock edge
always @(posedge clk or negedge clk)
    q <= (clk) ? q_rising : q_falling;

endmodule