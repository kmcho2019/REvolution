module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

parameter RESET_VAL = 8'h34;  // Parameter for reset value

always @(negedge clk) begin
    if (reset) begin
        q <= RESET_VAL;  // Apply parameterized reset value
    end else begin
        q <= d;         // Normal operation
    end
end

endmodule