module TopModule (
    input  [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different
);

    integer i;
    always @(*) begin
        // Initialize outputs to zero
        out_both      = 100'b0;
        out_any       = 100'b0;
        out_different = 100'b0;

        // Compute out_both: bit i = in[i] & in[i+1] for i=0..98; out_both[99]=0
        for (i = 0; i < 99; i = i + 1) begin
            out_both[i] = in[i] & in[i+1];
        end
        out_both[99] = 1'b0;

        // Compute out_any: bit i = in[i] | in[i-1] for i=1..99; out_any[0]=0
        for (i = 1; i < 100; i = i + 1) begin
            out_any[i] = in[i] | in[i-1];
        end
        out_any[0] = 1'b0;

        // Compute out_different: bit i = in[i] ^ in[(i+1) % 100] (wrap-around)
        for (i = 0; i < 100; i = i + 1) begin
            out_different[i] = in[i] ^ in[(i + 1) % 100];
        end
    end

endmodule