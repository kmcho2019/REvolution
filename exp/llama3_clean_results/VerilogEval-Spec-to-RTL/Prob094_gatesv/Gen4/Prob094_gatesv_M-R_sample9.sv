module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    integer i;

    always @(*) begin
        out_both[3] = 1'b0;
        out_any[0] = in[0];
        out_different[3] = (in[3] ^ in[0]);
        for (i = 0; i < 3; i++) begin
            out_both[i] = in[i] & in[i+1];
            out_any[i+1] = in[i+1] | in[i];
            out_different[i] = (in[i] ^ in[i+1]);
        end
    end

endmodule