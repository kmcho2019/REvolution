module TopModule (
    input  wire [3:0] in,
    output reg  [3:0] out_both,
    output reg  [3:0] out_any,
    output reg  [3:0] out_different
);

    integer i;
    always @(*) begin
        // Default assignments for out_both and out_any to zero
        out_both = 4'b0000;
        out_any  = 4'b0000;
        out_different = 4'b0000;

        for (i = 0; i < 4; i = i + 1) begin
            // out_both[i]: check both this bit and left neighbor are 1, except for i=3 (no left neighbor)
            if (i < 3)
                out_both[i] = in[i] & in[i+1];
            else
                out_both[i] = 1'b0;

            // out_any[i]: check this bit or right neighbor is 1, except for i=0 (no right neighbor)
            if (i > 0)
                out_any[i] = in[i] | in[i-1];
            else
                out_any[i] = 1'b0;

            // out_different[i]: XOR of this bit and left neighbor with wrap-around at boundary
            // left neighbor for i=3 is in[0]
            if (i < 3)
                out_different[i] = in[i] ^ in[i+1];
            else
                out_different[i] = in[i] ^ in[0];
        end
    end

endmodule