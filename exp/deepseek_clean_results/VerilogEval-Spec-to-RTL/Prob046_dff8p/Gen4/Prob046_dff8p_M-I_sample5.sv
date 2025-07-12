module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(negedge clk) begin
    if (reset) begin
        q <= 8'b00110100;  // Direct constant assignment of 0x34
    end else begin
        q <= d;
    end
end

endmodule