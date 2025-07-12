module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

localparam RESET_VALUE = 8'h34;

always @(negedge clk) begin
    if (reset) begin
        q <= RESET_VALUE;
    end else begin
        q <= d;
    end
end

endmodule