module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

parameter RESET_VAL = 8'h34;
reg [7:0] d_prev;
wire clk_enable = (d != d_prev) || reset;  // Clock gating condition

always @(negedge clk) begin
    d_prev <= d;  // Store previous input for comparison
    
    if (clk_enable) begin
        if (reset) begin
            q <= RESET_VAL;  // Parameterized reset value
        end else begin
            q <= d;          // Normal operation
        end
    end
end

endmodule