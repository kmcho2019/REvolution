module TopModule (
    input  clk,
    input  ar,    // Asynchronous reset, active high
    input  d,
    output reg q
);

// Positive edge-triggered D flip-flop with asynchronous reset
always @(posedge clk or posedge ar) begin
    if (ar)
        q <= 1'b0;  // Asynchronous reset clears output immediately
    else
        q <= d;     // On clock edge, capture input d
end

endmodule