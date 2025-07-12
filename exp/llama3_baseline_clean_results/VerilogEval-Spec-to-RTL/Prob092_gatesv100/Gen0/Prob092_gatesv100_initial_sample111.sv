module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: both the current bit and its neighbor to the left are '1'
    always @(in) begin
        out_both[99] = 1'b0; // no left neighbor for the most significant bit
        for (int i = 98; i >= 0; i--) begin
            out_both[i] = in[i] && in[i + 1];
        end
    end

    // out_any: either the current bit or its neighbor to the right is '1'
    always @(in) begin
        out_any[0] = 1'b0; // no right neighbor for the least significant bit
        for (int i = 1; i <= 99; i++) begin
            out_any[i] = in[i] || in[i - 1];
        end
    end

    // out_different: the current bit is different from its neighbor to the left
    always @(in) begin
        out_different[99] = in[99] !== in[0]; // wrap around to the least significant bit
        for (int i = 98; i >= 0; i--) begin
            out_different[i] = in[i] !== in[i + 1];
        end
    end

endmodule