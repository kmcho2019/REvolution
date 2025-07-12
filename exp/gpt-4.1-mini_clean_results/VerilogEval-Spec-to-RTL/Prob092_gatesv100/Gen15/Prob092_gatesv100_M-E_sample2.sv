module TopModule (
    input  wire [99:0] in,
    output reg  [99:0] out_both,
    output reg  [99:0] out_any,
    output reg  [99:0] out_different
);

    integer i;
    always @(*) begin
        for (i = 0; i < 100; i = i + 1) begin
            // out_both: check current bit and neighbor to left (i+1)
            if (i < 99)
                out_both[i] = in[i] & in[i+1];
            else
                out_both[i] = 1'b0; // no left neighbor for bit 99

            // out_any: check current bit and neighbor to right (i-1)
            if (i > 0)
                out_any[i] = in[i] | in[i-1];
            else
                out_any[i] = 1'b0; // no right neighbor for bit 0

            // out_different: XOR with neighbor to left with wrap-around
            // neighbor index = (i + 1) mod 100
            out_different[i] = in[i] ^ in[(i + 1) % 100];
        end
    end

endmodule