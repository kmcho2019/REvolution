module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;  // Synchronous reset
    end
    else if (slowena) begin
        if (q == 4'b1001) begin  // If count is 9
            q <= 4'b0000;         // Wrap around to 0
        end
        else begin
            q <= q + 1'b1;       // Otherwise increment
        end
    end
end

endmodule