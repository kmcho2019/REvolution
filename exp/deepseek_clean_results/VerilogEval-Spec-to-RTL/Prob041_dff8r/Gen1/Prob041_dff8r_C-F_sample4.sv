module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 8'b00000000;  // Explicit synchronous reset
    end
    else begin
        q <= d;            // Direct data path for minimal delay
    end
end

endmodule