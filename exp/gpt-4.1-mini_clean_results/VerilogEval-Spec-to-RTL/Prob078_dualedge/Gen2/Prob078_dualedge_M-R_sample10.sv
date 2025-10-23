module TopModule (
    input clk,
    input d,
    output reg q
);

reg q_rising, q_falling;

// Sample input on rising edge
always @(posedge clk) begin
    q_rising <= d;
end

// Sample input on falling edge
always @(negedge clk) begin
    q_falling <= d;
end

// Register output multiplexing on rising edge
always @(posedge clk) begin
    if (clk)
        q <= q_rising;
    else
        q <= q_falling;
end

endmodule