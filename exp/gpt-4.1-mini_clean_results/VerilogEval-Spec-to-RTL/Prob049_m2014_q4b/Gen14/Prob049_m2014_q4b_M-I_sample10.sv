module TopModule (
    input  clk,
    input  ar,   // Asynchronous active-high reset
    input  d,
    output reg q
);

// Positive-edge triggered D flip-flop with asynchronous active-high reset
always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0;
    end else begin
        // Update q only if d differs to potentially reduce toggling
        if (d != q)
            q <= d;
    end
end

endmodule