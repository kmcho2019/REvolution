module TopModule(
    input  [31:0] in,
    output [31:0] out
);

integer i;
always @(*) begin
    for (i = 0; i < 4; i++) begin
        out[(i*8)+:8] = in[(3-i)*8 +: 8];
    end
end

endmodule