module TopModule (
    input  clk,
    input  ar,   // Asynchronous active-high reset
    input  d,
    output reg q
);

// Initialize q to zero at simulation start for known state (ignored by synthesis)
initial begin
    q = 1'b0;
end

// Positive-edge triggered D flip-flop with asynchronous active-high reset
always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0;   // Asynchronous reset overrides q immediately
    end else begin
        q <= d;      // On clock edge, capture input d
    end
end

endmodule