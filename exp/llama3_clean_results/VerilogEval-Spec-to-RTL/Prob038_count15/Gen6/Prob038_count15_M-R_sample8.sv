module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0; // Synchronous reset to 0
    end else begin
        q <= (q == 4'd15) ? 4'd0 : q + 1; // Increment or reset counter
    end
end

endmodule