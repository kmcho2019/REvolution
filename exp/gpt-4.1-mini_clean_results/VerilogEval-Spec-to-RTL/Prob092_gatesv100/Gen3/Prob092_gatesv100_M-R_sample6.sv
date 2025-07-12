module TopModule(
    input  wire [99:0] in,
    output reg  [99:0] out_both,
    output reg  [99:0] out_any,
    output reg  [99:0] out_different
);

integer i;

always @(*) begin
    // Initialize outputs to zero
    out_both = 100'b0;
    out_any = 100'b0;
    out_different = 100'b0;

    for (i = 0; i < 99; i = i + 1) begin
        // out_both[i] = in[i] & in[i+1]
        out_both[i] = in[i] & in[i+1];

        // out_any[i+1] = in[i+1] | in[i]
        out_any[i+1] = in[i+1] | in[i];

        // out_different[i] = in[i] ^ in[i+1]
        out_different[i] = in[i] ^ in[i+1];
    end

    // Handle last bits and wrap-around for out_different[99]
    out_both[99] = 1'b0;                // no left neighbor for bit 99
    out_any[0] = 1'b0;                  // no right neighbor for bit 0
    out_different[99] = in[99] ^ in[0]; // wrap-around neighbor for bit 99
end

endmodule