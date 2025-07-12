module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

parameter TERMINAL_COUNT = 4'b1001; // Binary 9

always @(posedge clk) begin
    case ({reset, q})
        {1'b1, 4'b????}: q <= 4'b0000;  // Reset case
        {1'b0, TERMINAL_COUNT}: q <= 4'b0000;  // Rollover case
        default: q <= q + 1'b1;  // Normal increment
    endcase
end

endmodule