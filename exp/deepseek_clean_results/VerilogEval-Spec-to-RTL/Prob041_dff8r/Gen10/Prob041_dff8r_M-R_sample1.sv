module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 8'b0;  // Synchronous reset to zero for all 8 bits
    end else begin
        q <= d;     // Normal operation - capture input on rising edge
    end
end

endmodule