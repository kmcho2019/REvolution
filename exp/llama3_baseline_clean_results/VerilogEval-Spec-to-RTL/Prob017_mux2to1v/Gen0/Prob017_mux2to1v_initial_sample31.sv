module TopModule(
    input [99:0] a,   // 100-bit input
    input [99:0] b,   // 100-bit input
    input sel,
    output reg [99:0] out  // 100-bit output
);

always @(*) begin
    out = sel ? b : a;
end

endmodule