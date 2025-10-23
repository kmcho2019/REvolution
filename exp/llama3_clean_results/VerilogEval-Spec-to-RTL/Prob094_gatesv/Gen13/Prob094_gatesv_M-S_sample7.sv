module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    integer i;
    always @(*) begin
        for (i = 0; i < 4; i++) begin
            out_both[i] = (i < 3)? (in[i] & in[i+1]) : 1'b0;
            out_any[i] = (i > 0)? (in[i] | in[i-1]) : in[i];
            out_different[i] = in[i] ^ in[(i+1)%4];
        end
    end

endmodule