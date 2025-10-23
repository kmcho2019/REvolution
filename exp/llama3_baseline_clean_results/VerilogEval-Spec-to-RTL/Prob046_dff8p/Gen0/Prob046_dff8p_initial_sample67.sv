module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q;

initial q = 8'd52;  // Initialize q to 0x34

always @(posedge reset or negedge clk) begin
    if (reset) begin
        q <= 8'd52;  // Reset to 0x34
    end else begin
        q <= d;  // Assign d to q on the negative edge of clk
    end
end

endmodule