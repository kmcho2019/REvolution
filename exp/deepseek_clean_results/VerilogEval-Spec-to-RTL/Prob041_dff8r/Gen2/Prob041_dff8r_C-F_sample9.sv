module TopModule (
    input wire clk,
    input wire reset,
    input wire [7:0] d,
    output reg [7:0] q
);

// 8-bit register with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        q <= 8'b00000000;  // Explicit synchronous reset
    end else begin
        q <= d;            // Data capture on rising edge
    end
end

endmodule