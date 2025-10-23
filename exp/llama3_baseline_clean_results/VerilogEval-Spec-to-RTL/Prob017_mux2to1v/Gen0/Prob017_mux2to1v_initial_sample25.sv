module TopModule(
    input [99:0] a,  // 100-bit input
    input [99:0] b,  // 100-bit input
    input sel,
    output [99:0] out  // 100-bit output
);

always @(*) begin
    if (sel == 0) begin
        out = a;
    end else begin
        out = b;
    end
end

endmodule