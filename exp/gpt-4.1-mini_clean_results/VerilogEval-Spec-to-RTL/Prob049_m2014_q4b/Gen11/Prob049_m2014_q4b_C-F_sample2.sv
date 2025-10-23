module TopModule (
    input clk,
    input ar,      // Asynchronous active-high reset
    input d,
    output reg q
);

// Initialize q to zero at simulation start for known initial state (ignored by synthesis)
initial q = 1'b0;

// Positive-edge triggered D flip-flop with asynchronous reset
always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0;       // Asynchronously reset output when ar is asserted
    end else begin
        q <= d;          // On clock edge, sample input d
    end
end

endmodule