module TopModule (
    input  [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different
);

    integer i;
    always @(*) begin
        // Default assignments for edge bits
        out_both[99] = 1'b0;    // MSB has no left neighbor
        out_any[0]   = 1'b0;    // LSB has no right neighbor

        // For out_different, bit 99 wraps around to neighbor 0
        out_different[99] = in[99] ^ in[0];

        // Loop through bits 0 to 98 for out_both and out_different
        for (i = 0; i < 99; i = i + 1) begin
            // out_both[i] = in[i] & in[i+1]
            out_both[i] = in[i] & in[i+1];
            // out_different[i] = in[i] ^ in[i+1]
            out_different[i] = in[i] ^ in[i+1];
        end

        // Loop through bits 1 to 99 for out_any
        for (i = 1; i < 100; i = i + 1) begin
            // out_any[i] = in[i] | in[i-1]
            out_any[i] = in[i] | in[i-1];
        end
    end

endmodule