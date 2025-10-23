module TopModule(
    input [99:0] in,  // 100 bits
    output [99:0] out  // 100 bits
);

integer i;
always @(*) begin
    for (i = 0; i < 100; i++) begin
        out[99 - i] = in[i];
    end
end

endmodule