module TopModule(
    input  [3:0] in,
    output [2:0] out_both,
    output [1:3] out_any,
    output [3:0] out_different
);

integer i;

always @(*) begin
    for (i = 0; i < 3; i++) begin
        out_both[i] = in[i] & in[i + 1];
        out_any[i + 1] = in[i] | in[i + 1];
    end
    for (i = 0; i < 4; i++) begin
        out_different[i] = in[i] ^ in[(i + 1) % 4];
    end
end

endmodule