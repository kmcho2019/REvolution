module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    // Use a multiplexer-like approach to select between reset and data
    q <= r ? 1'b0 : d;
end

endmodule