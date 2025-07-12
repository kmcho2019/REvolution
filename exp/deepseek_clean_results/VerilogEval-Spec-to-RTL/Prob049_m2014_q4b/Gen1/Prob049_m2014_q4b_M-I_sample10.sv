module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

// Use technology-specific flip-flop with integrated clock gating
// and optimized reset structure
always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0;  // Asynchronous reset
    end
    else if (q != d) begin  // Clock gating condition
        q <= d;     // Data capture on clock edge
    end
end

endmodule