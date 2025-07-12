module TopModule (
    input  [99:0] in,  // 100-bit input
    output [99:0] out  // 100-bit output
);

integer i;
always @(*) begin
    for (i = 0; i < 100; i++) begin
        out[i] = in[99 - i];
    end
end

endmodule