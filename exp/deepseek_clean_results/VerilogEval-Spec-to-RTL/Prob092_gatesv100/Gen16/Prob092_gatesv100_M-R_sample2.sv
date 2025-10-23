module TopModule (
    input [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different
);

    always_comb begin
        // out_both calculation
        out_both[99] = 1'b0;  // MSB has no left neighbor
        for (int i = 98; i >= 0; i--) begin
            out_both[i] = in[i] & in[i+1];
        end

        // out_any calculation
        out_any[0] = 1'b0;  // LSB has no right neighbor
        for (int i = 1; i < 100; i++) begin
            out_any[i] = in[i] | in[i-1];
        end

        // out_different calculation with wrap-around
        out_different[99] = in[99] ^ in[0];  // Wrap-around case
        for (int i = 98; i >= 0; i--) begin
            out_different[i] = in[i] ^ in[i+1];
        end
    end

endmodule