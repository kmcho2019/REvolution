module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] shift_reg;

// Hardcoded reset value
localparam [7:0] RESET_VAL = 8'b00110100;

always @(negedge clk) begin
    if (reset) begin
        shift_reg <= RESET_VAL;  // Parallel load of reset value
    end else begin
        shift_reg <= d;           // Normal operation
    end
end

assign q = shift_reg;

endmodule