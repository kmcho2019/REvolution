module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    q <= r ? 1'b0 : d; // Directly incorporate reset and data logic into the clocked process
end

endmodule