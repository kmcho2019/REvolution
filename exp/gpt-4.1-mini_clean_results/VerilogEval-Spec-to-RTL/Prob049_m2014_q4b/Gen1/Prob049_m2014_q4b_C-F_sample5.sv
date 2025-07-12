module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

// Positive edge triggered D flip-flop with asynchronous active-high reset
always @(posedge clk or posedge ar) begin
    if (ar)
        q <= 1'b0;  // Asynchronous reset clears q immediately
    else
        q <= d;     // Capture input d on rising clock edge
end

// Optional: initialize q to zero for simulation clarity
initial begin
    q = 1'b0;
end

endmodule