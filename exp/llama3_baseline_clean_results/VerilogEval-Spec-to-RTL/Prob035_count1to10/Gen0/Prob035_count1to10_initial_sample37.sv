module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] q;

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd1; // Reset to 1
    end else if (q < 10) begin
        q <= q + 1; // Increment counter
    end else begin
        q <= 4'd1; // Reset counter to 1 when it reaches 10
    end
end

endmodule