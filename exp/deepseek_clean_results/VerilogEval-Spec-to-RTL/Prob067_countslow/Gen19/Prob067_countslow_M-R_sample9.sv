module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

// State register with synchronous reset and enable
always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;  // Reset to 0
    end else if (slowena) begin
        if (q == 4'b1001) begin  // If at 9
            q <= 4'b0000;        // Wrap to 0
        end else begin
            q <= q + 1'b1;       // Increment otherwise
        end
    end
    // If slowena=0, q maintains its value
end

endmodule