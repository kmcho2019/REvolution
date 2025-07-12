module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    if (r) q <= 0; // Active high synchronous reset
    else q <= d;   // Load input data on rising edge of clk
end

endmodule