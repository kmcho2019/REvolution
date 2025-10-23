module TopModule(
    input [99:0] a,
    input [99:0] b,
    input sel,
    output reg [99:0] out
);

always @(*) begin
    out = (sel == 1'b0) ? a : b;
end

endmodule