module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg wrap;  // Registered wrap condition

always @(posedge clk) begin
    wrap <= (q == 4'b1010);  // Pre-compute wrap condition
end

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;        // Direct synchronous reset
    end
    else if (wrap) begin
        q <= 4'b0001;        // Wrap around using registered signal
    end
    else if (q != 4'b1010) begin  // Clock gating style condition
        q <= q + 1;          // Conditional increment
    end
end

endmodule