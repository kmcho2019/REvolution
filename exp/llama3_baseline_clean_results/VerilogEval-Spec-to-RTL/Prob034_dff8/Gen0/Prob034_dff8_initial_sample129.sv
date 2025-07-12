module TopModule(
    input           clk,  // clock signal
    input [7:0]      d,   // 8-bit input data
    output reg [7:0] q    // 8-bit output data
);

always @(posedge clk) begin
    q <= d;
end

endmodule