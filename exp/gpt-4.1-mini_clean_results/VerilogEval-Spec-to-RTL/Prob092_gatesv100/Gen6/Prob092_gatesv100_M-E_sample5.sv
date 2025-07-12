module TopModule(
    input  wire [99:0] in,
    output reg  [99:0] out_both,
    output reg  [99:0] out_any,
    output reg  [99:0] out_different
);

    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : bit_calc
            always @(*) begin
                // out_both[i]: in[i] & in[i+1], except i=99 which is 0
                if (i < 99)
                    out_both[i] = in[i] & in[i+1];
                else
                    out_both[i] = 1'b0;

                // out_any[i]: in[i] | in[i-1], except i=0 which is 0
                if (i > 0)
                    out_any[i] = in[i] | in[i-1];
                else
                    out_any[i] = 1'b0;

                // out_different[i]: in[i] ^ in[(i+1)%100] with wrap-around
                if (i < 99)
                    out_different[i] = in[i] ^ in[i+1];
                else
                    out_different[i] = in[99] ^ in[0];
            end
        end
    endgenerate

endmodule