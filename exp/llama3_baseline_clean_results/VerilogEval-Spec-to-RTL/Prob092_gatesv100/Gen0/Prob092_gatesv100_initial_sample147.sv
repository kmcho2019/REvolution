module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: Each bit indicates whether both the corresponding input bit and its neighbor to the left are '1'.
    always @(*) begin
        out_both[99] = 1'b0;  // No neighbor to the left for the most significant bit
        for (int i = 98; i >= 0; i--) begin
            out_both[i] = in[i] & in[i+1];
        end
    end

    // out_any: Each bit indicates whether any of the corresponding input bit and its neighbor to the right are '1'.
    always @(*) begin
        out_any[0] = 1'b0;  // No neighbor to the right for the least significant bit
        for (int i = 1; i <= 99; i++) begin
            out_any[i] = in[i] | in[i-1];
        end
    end

    // out_different: Each bit indicates whether the corresponding input bit is different from its neighbor to the left.
    always @(*) begin
        for (int i = 98; i >= 0; i--) begin
            out_different[i] = in[i] ^ in[i+1];
        end
        out_different[99] = in[99] ^ in[0];  // Wrap-around condition for the most significant bit
    end

endmodule