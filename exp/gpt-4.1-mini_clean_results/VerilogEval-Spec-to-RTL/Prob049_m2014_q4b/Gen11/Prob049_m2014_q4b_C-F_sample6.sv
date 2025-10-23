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

// Positive-edge triggered D flip-flop with asynchronous reset
always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule