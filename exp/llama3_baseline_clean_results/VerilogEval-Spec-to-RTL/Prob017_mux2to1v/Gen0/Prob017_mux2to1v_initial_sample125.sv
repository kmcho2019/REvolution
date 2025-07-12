module TopModule(
    input [99:0] a,
    input [99:0] b,
    input sel,
    output reg [99:0] out
);

always @(*) begin
    out = sel ? b : a;
end

endmodule