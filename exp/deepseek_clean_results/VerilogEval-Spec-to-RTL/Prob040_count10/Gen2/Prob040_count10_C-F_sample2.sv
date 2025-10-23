module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Decade counter (0-9) with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        q <= 0;          // Reset to 0 when reset is active
    end
    else begin
        if (q == 9) begin // When reaching 9
            q <= 0;       // Wrap around to 0
        end
        else begin
            q <= q + 1;   // Increment count otherwise
        end
    end
end

endmodule