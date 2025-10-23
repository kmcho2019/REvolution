module TopModule (
    input [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different
);

    always @(*) begin
        // out_both calculation
        out_both[99] = 1'b0;  // No left neighbor for MSB
        for (int i = 0; i < 99; i = i + 1) begin
            out_both[i] = in[i] & in[i+1];
        end

        // out_any calculation
        out_any[0] = 1'b0;    // No right neighbor for LSB
        for (int i = 1; i < 100; i = i + 1) begin
            out_any[i] = in[i] | in[i-1];
        end

        // out_different calculation (with wrap-around)
        for (int i = 0; i < 99; i = i + 1) begin
            out_different[i] = in[i] ^ in[i+1];
        end
        out_different[99] = in[99] ^ in[0];  // Wrap-around case
    end

endmodule