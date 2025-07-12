module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

parameter RESET_VAL = 8'h34;
reg [7:0] prev_d;
reg clk_en;

always @(negedge clk) begin
    prev_d <= d;
    clk_en <= (d != prev_d) || reset;
end

always @(negedge clk) begin
    if (!clk_en) begin
        q <= q;  // Hold previous value
    end else if (reset) begin
        q <= RESET_VAL;
    end else begin
        q <= d;
    end
end

endmodule