module TopModule(
    input  [3:0] in,
    output reg [3:0] out_both,
    output reg [3:0] out_any,
    output reg [3:0] out_different
);

    integer i;

    always @(*) begin
        out_both = 4'b0000;
        out_any = 4'b0000;
        out_different = 4'b0000;

        for (i = 0; i < 3; i++) begin
            out_both[i] = in[i] & in[i+1];
            out_any[i+1] = in[i] | in[i+1];
            out_different[i] = in[i] ^ in[i+1];
        end

        out_any[0] = in[0];
        out_different[3] = in[3] ^ in[0];
    end

endmodule