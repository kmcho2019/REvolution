module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire wrap = (q == 4'b1010);  // Pre-compute wrap condition

always @(posedge clk) begin
    casex ({reset, wrap})
        2'b1?: q <= 4'b0001;  // Reset has highest priority
        2'b01: q <= 4'b0001;  // Wrap around
        default: q <= q + 1;  // Normal increment
    endcase
end

endmodule