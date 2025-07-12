module TopModule (
    input  clk,
    input  ar,   // Asynchronous active-high reset
    input  d,
    output reg q
);

// Positive-edge triggered D flip-flop with asynchronous active-high reset
always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0;   // Asynchronously reset output to 0 when ar is asserted
    end else begin
        q <= d;      // On clock edge, capture d
    end
end

endmodule