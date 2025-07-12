module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

// Parameter for reset value (0x34)
parameter RESET_VAL = 8'b00110100;

always @(negedge clk) begin
    q <= reset ? RESET_VAL : d;
end

endmodule