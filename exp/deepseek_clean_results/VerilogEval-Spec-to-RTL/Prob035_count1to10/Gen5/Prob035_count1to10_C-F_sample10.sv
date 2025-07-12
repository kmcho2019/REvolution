module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Optimized wrap-around detection for decimal 10 (1010)
wire wrap_around = (q == 4'b1010);  // Using equality for clarity, synthesis will optimize

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;  // Reset to 1
    end
    else if (wrap_around) begin
        q <= 4'b0001;  // Wrap around to 1 when reaching 10
    end
    else begin
        q <= q + 4'b0001;  // Increment otherwise
    end
end

endmodule