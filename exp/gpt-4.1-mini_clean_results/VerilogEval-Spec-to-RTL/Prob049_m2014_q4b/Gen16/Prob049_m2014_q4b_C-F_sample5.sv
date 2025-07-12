module TopModule (
    input  clk,
    input  ar,   // Asynchronous active-high reset
    input  d,
    output reg q
) /* synthesis syn_preserve = 1 */ ; // Preserve during optimization

// Positive-edge triggered D flip-flop with asynchronous active-high reset
always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0;       // Asynchronous reset clears q
    end else begin
        q <= d;          // On clock edge, sample d
    end
end

endmodule