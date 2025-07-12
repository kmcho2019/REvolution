module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

// Positive edge-triggered with async reset
always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0;  // Async reset has priority
    end else begin
        q <= d;     // Normal DFF operation on clock edge
    end
end

endmodule