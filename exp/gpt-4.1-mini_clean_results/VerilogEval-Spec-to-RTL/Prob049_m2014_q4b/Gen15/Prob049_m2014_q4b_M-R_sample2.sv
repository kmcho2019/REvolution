module TopModule (
    input  clk,
    input  ar,   // Asynchronous active-high reset
    input  d,
    output reg q
);

// Internal asynchronous reset signal (wire)
wire async_reset = ar;

// Positive-edge triggered D flip-flop with asynchronous reset implemented by a clocked always block and asynchronous reset wire
always @(posedge clk) begin
    if (async_reset) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule