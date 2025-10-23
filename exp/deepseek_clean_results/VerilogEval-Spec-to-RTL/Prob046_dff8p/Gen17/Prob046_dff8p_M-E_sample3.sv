module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

localparam RESET_VAL = 8'h34;

always @(negedge clk) begin
    if (reset) begin
        q <= RESET_VAL;  // Direct assignment of reset value
    end else begin
        q <= d;          // Normal operation
    end
end

endmodule