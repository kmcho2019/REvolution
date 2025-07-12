module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q;

always @ (posedge clk) begin
    if (reset) begin
        q <= 8'b0; // Synchronous reset, set q to 0 when reset is high
    end else begin
        q <= d; // On positive edge of clk, load d into q if not resetting
    end
end

endmodule