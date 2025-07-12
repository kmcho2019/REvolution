module TopModule(
    input  wire [99:0] in,
    output reg  [99:0] out_both,
    output reg  [99:0] out_any,
    output reg  [99:0] out_different
);

    integer i;
    always @* begin
        // Initialize outputs to zero by default
        out_both = 100'b0;
        out_any = 100'b0;
        out_different = 100'b0;

        // Compute out_both: out_both[i] = in[i] & in[i+1], for i=0 to 98; out_both[99]=0
        for (i = 0; i < 99; i = i + 1) begin
            out_both[i] = in[i] & in[i+1];
        end
        out_both[99] = 1'b0; // explicitly assign as per spec

        // Compute out_any: out_any[i] = in[i] | in[i-1], for i=1 to 99; out_any[0]=0
        for (i = 1; i < 100; i = i + 1) begin
            out_any[i] = in[i] | in[i-1];
        end
        out_any[0] = 1'b0; // explicitly assign as per spec

        // Compute out_different: out_different[i] = in[i] ^ in[(i-1) mod 100]
        // wrapping neighbor to the left of in[0] is in[99]
        for (i = 0; i < 100; i = i + 1) begin
            out_different[i] = in[i] ^ in[(i == 0) ? 99 : i-1];
        end
    end

endmodule