module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q;

always @(negedge clk) begin
    if (reset) begin
        q <= 8'h34; // Synchronously reset q to 0x34 on the negative edge of clk when reset is high
    end else begin
        q <= d; // On the negative edge of clk when reset is not high, load d into q
    end
end

endmodule