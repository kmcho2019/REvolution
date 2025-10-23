module TopModule(
    input  [3:0] in,
    output [3:1] out_both,
    output [2:0] out_any,
    output [3:0] out_different
);

integer i;

always @(*) begin
    for (i = 3; i >= 1; i--) begin
        out_both[i] = in[i] & in[i-1];
    end
    for (i = 2; i >= 0; i--) begin
        out_any[i] = in[i] | in[i+1];
    end
    for (i = 3; i >= 0; i--) begin
        if (i == 0)
            out_different[i] = in[i]!= in[3];
        else
            out_different[i] = in[i]!= in[i-1];
    end
end

endmodule