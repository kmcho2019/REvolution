module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

parameter RESET_VAL = 8'h34;  // Reset value is 0x34
reg [7:0] d_prev;
wire clk_en = reset || (d != d_prev);

always @(negedge clk) begin
    d_prev <= d;
    if (clk_en) begin
        if (reset) begin
            q <= RESET_VAL;
        end else begin
            q <= d;
        end
    end
end

endmodule