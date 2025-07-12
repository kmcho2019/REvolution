module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

localparam RESET_VALUE = 8'b00110100;  // 0x34
reg [7:0] d_prev;
wire data_changed = (d != d_prev);

always @(negedge clk) begin
    d_prev <= d;
    if (reset) begin
        q <= RESET_VALUE;
    end else if (data_changed) begin
        q <= d;
    end
end

endmodule