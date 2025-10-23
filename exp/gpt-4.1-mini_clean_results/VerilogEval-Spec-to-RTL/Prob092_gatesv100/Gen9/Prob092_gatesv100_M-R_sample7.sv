module TopModule (
    input  [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different
);

    integer i;
    always @(*) begin
        // Compute out_both
        // For i = 0 to 98: out_both[i] = in[i] & in[i+1]
        // For i = 99: out_both[99] = 0
        for (i = 0; i < 99; i = i + 1) begin
            out_both[i] = in[i] & in[i+1];
        end
        out_both[99] = 1'b0;

        // Compute out_any
        // For i = 1 to 99: out_any[i] = in[i] | in[i-1]
        // For i = 0: out_any[0] = 0
        out_any[0] = 1'b0;
        for (i = 1; i < 100; i = i + 1) begin
            out_any[i] = in[i] | in[i-1];
        end

        // Compute out_different with wrap-around
        // For i = 0 to 98: out_different[i] = in[i] ^ in[i+1]
        // For i = 99: out_different[99] = in[99] ^ in[0]
        for (i = 0; i < 99; i = i + 1) begin
            out_different[i] = in[i] ^ in[i+1];
        end
        out_different[99] = in[99] ^ in[0];
    end

endmodule