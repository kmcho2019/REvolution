module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    integer i;
    always @(*) begin
        for (i = 0; i < 100; i++) begin
            out_both[i] = (i < 99)? (in[i] && in[i+1]) : 1'b0;
            out_any[i] = (i > 0)? (in[i] || in[i-1]) : 1'b0;
            out_different[i] = in[i] ^ ((i == 99)? in[0] : in[i+1]);
        end
    end

endmodule