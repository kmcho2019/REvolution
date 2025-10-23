module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 8'd0; // Reset all bits to zero when reset is high
    end else begin
        q <= d; // Load data into q on the positive edge of clk when reset is low
    end
end

endmodule