module TopModule (
    input               clk,
    input               reset,
    input       [7:0]   d,
    output reg  [7:0]   q
);

parameter RESET_VAL = 8'h34;
reg sync_reset;

// Single stage reset synchronizer
always @(negedge clk) begin
    sync_reset <= reset;
end

always @(negedge clk) begin
    if (sync_reset) begin
        q <= RESET_VAL;
    end else begin
        q <= d;
    end
end

endmodule