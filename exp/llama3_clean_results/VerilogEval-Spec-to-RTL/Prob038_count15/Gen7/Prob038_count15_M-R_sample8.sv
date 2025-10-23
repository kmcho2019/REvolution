module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

always_ff @(posedge clk) begin
    if (reset) q <= 0;
    else q <= q + 1;
end

endmodule