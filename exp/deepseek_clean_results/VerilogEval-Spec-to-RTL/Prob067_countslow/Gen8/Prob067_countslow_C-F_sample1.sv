module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;  // Synchronous reset to 0
    end
    else if (slowena) begin
        // Efficient rollover detection using q[3] & q[0] (detects 9)
        q <= (q == 4'd9) ? 4'd0 : q + 1'b1;
    end
end

endmodule