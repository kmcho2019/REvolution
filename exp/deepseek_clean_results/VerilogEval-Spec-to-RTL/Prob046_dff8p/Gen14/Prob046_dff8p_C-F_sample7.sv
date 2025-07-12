module TopModule #(
    parameter RESET_VAL = 8'h34
) (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(negedge clk) begin
    if (reset) begin
        q <= RESET_VAL;
    end else begin
        q <= d;
    end
end

endmodule