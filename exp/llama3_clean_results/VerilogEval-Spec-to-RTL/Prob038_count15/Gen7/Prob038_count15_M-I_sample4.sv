module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

localparam RESET_VALUE = 4'd0;
localparam MAX_COUNT = 4'd15;

always @(posedge clk) begin
    if (reset) q <= RESET_VALUE;
    else if (q == MAX_COUNT) q <= RESET_VALUE;
    else q <= q + 1;
end

endmodule