module TopModule(
    input  [3:0] in,
    output reg [3:0] out_both,
    output reg [3:0] out_any,
    output reg [3:0] out_different
);

    integer i;
    always @(*) begin
        // Default outputs
        out_both = 4'b0000;
        out_any = 4'b0000;
        out_different = 4'b0000;

        for (i = 0; i < 4; i = i + 1) begin
            // out_both[i]: 1 if both in[i] and neighbor to left (i+1) are 1
            // no neighbor for i=3, so skip or assign 0
            if (i < 3)
                out_both[i] = in[i] & in[i+1];
            else
                out_both[i] = 1'b0;

            // out_any[i]: 1 if either in[i] or neighbor to right (i-1) is 1
            // no neighbor for i=0, so assign 0
            if (i > 0)
                out_any[i] = in[i] | in[i-1];
            else
                out_any[i] = 1'b0;

            // out_different[i]: 1 if in[i] differs from neighbor to left (i+1 mod 4)
            out_different[i] = in[i] ^ in[(i+1) % 4];
        end
    end

endmodule