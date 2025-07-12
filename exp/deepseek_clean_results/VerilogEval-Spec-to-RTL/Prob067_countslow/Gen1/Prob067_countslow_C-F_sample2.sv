module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;          // Synchronous reset
    end
    else if (slowena) begin // Only increment when enabled
        q <= (q == 4'd9) ? 4'd0 : q + 4'd1; // Ternary for concise wrap-around
    end
end

endmodule