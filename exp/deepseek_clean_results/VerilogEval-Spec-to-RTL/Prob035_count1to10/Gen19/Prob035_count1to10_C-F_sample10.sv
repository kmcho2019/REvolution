module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;  // Synchronous reset to 1
    end
    else begin
        if (q == 4'b1010) begin  // Clear comparison for 10
            q <= 4'b0001;        // Wrap around to 1
        end
        else begin
            q <= q + 4'b0001;    // Increment otherwise
        end
    end
end

endmodule