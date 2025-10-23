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
        out_any[i + 1] = in[i + 1] | in[i];
    end
    for (i = 0; i < 4; i++) begin
        if (i == 0)
            out_different[i] = in[i] ^ in[3];
        else
            out_different[i] = in[i] ^ in[i - 1];
    end
end

endmodule