module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;  // Reset to 1
    end
    else begin
        if (q[3] & q[1]) begin  // Simplified check for 10 (1010)
            q <= 4'b0001;        // Wrap around to 1
        end
        else begin
            q <= q + 4'b0001;    // Otherwise increment
        end
    end
end

endmodule