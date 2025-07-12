module TopModule (
    input clk,
    input ar,      // Asynchronous active-high reset
    input d,
    output reg q
);

// D flip-flop with asynchronous reset
always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0;       // Reset output asynchronously when ar is high
    end else begin
        q <= d;          // On clock edge, sample input d
    end
end

endmodule