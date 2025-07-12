module TopModule(
    input  wire [99:0] in,
    output reg  [99:0] out_both,
    output reg  [99:0] out_any,
    output reg  [99:0] out_different
);

    integer i;
    always @(*) begin
        for (i = 0; i < 100; i = i + 1) begin
            // out_both[i]: both in[i] and its left neighbor in[i+1], except for i=99
            if (i < 99)
                out_both[i] = in[i] & in[i+1];
            else
                out_both[i] = 1'b0;

            // out_any[i]: any of in[i] or right neighbor in[i-1], except for i=0
            if (i > 0)
                out_any[i] = in[i] | in[i-1];
            else
                out_any[i] = 1'b0;

            // out_different[i]: in[i] different from left neighbor with wrap-around
            if (i == 0)
                out_different[i] = in[i] ^ in[99];
            else
                out_different[i] = in[i] ^ in[i-1];
        end
    end

endmodule