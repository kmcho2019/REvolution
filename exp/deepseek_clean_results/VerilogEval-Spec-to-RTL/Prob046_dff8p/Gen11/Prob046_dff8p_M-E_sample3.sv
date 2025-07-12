module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

// Parameterized reset value
localparam RESET_VAL = 8'h34;

always @(negedge clk) begin
    if (reset) begin
        q <= RESET_VAL;  // Synchronous reset to 0x34
    end else begin
        q <= d;         // Normal operation
    end
end

endmodule