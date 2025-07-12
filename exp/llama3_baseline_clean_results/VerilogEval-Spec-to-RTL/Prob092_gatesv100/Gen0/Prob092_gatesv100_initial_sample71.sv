module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Generate output out_both
    always @(in) begin
        out_both[99] = 1'b0; // Most significant bit has no left neighbor
        for (int i = 98; i >= 0; i--) begin
            out_both[i] = in[i] & in[i+1];
        end
    end

    // Generate output out_any
    always @(in) begin
        out_any[0] = 1'b0; // Least significant bit has no right neighbor
        for (int i = 1; i <= 99; i++) begin
            out_any[i] = in[i] | in[i-1];
        end
    end

    // Generate output out_different
    always @(in) begin
        for (int i = 0; i <= 98; i++) begin
            out_different[i] = in[i] ^ in[i+1];
        end
        out_different[99] = in[99] ^ in[0]; // Circular comparison for MSB
    end

endmodule