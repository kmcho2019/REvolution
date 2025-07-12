module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0; // Reset the counter to 0
    end else if (q == 4'd15) begin
        q <= 4'd0; // Wrap around to 0 after reaching 15
    end else begin
        q <= q + 1; // Increment the counter
    end
end

endmodule