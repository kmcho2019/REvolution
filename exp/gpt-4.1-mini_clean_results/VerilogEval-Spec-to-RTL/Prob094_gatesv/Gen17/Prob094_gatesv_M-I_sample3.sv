module TopModule (
    input  wire [3:0] in,
    output reg  [3:0] out_both,
    output reg  [3:0] out_any,
    output reg  [3:0] out_different
);

    integer i;
    always @* begin
        // Default assignments for boundary bits
        out_both = 4'b0000;
        out_any = 4'b0000;
        out_different = 4'b0000;

        // out_both[i] = in[i] & in[i+1] for i=0..2; out_both[3]=0
        // out_any[i] = in[i] | in[i-1] for i=1..3; out_any[0]=0
        // out_different[i] = in[i] ^ in[(i+1)%4]
        for (i = 0; i < 4; i = i + 1) begin
            // out_both only valid for i=0..2
            if (i < 3)
                out_both[i] = in[i] & in[i+1];

            // out_any only valid for i=1..3
            if (i > 0)
                out_any[i] = in[i] | in[i-1];

            // out_different with wrap-around
            out_different[i] = in[i] ^ in[(i+1) % 4];
        end
    end

endmodule