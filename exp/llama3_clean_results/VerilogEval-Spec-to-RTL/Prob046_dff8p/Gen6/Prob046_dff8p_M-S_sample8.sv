module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(negedge clk) begin
    if (reset) begin
        q <= 8'h34; // Reset q to the specified value
    end else begin
        q <= d; // Update q with d on negative edge of clk
    end
end

endmodule