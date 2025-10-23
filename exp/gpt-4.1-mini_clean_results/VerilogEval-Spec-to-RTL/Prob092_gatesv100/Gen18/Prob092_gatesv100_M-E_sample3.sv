module TopModule(
    input  wire [99:0] in,
    output reg  [99:0] out_both,
    output reg  [99:0] out_any,
    output reg  [99:0] out_different
);

    integer i;
    always @(*) begin
        for (i = 0; i < 100; i = i + 1) begin
            // out_both[i]: both current bit and left neighbor are 1
            // left neighbor is in[i+1], except at i=99 (no left neighbor)
            if (i == 99)
                out_both[i] = 1'b0;
            else
                out_both[i] = in[i] & in[i+1];

            // out_any[i]: any of current bit or right neighbor is 1
            // right neighbor is in[i-1], except at i=0 (no right neighbor)
            if (i == 0)
                out_any[i] = 1'b0;
            else
                out_any[i] = in[i] | in[i-1];

            // out_different[i]: current bit different from left neighbor with wrap-around
            // left neighbor for i=0 is in[99]
            out_different[i] = in[i] ^ in[(i == 99) ? 0 : i+1];
        end
    end

endmodule