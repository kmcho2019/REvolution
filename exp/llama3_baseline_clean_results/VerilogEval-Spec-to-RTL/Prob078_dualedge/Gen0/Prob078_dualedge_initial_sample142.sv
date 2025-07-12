module TopModule(
    input  clk,
    input  d,
    output q
);

reg q_int; // Internal signal to hold the value of q

// Flip-flop triggered on the rising edge of clk
reg q_rising;
always @(posedge clk) begin
    q_rising <= d;
end

// Flip-flop triggered on the falling edge of clk
reg q_falling;
always @(negedge clk) begin
    q_falling <= d;
end

// Update q_int on every edge of clk
always @(posedge clk or negedge clk) begin
    q_int <= (clk) ? q_rising : q_falling;
end

assign q = q_int;

endmodule