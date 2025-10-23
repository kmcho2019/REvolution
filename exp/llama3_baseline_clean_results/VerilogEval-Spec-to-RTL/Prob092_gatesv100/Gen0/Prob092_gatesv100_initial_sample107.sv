module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// out_both: Each bit indicates whether both the corresponding input bit and its neighbor to the left are '1'
always @(*) begin
    for (int i = 0; i < 100; i++) begin
        if (i == 99) begin
            out_both[i] = 1'b0; // no neighbor to the left for in[99]
        end else begin
            out_both[i] = in[i] & in[i + 1];
        end
    end
end

// out_any: Each bit indicates whether any of the corresponding input bit and its neighbor to the right are '1'
always @(*) begin
    for (int i = 0; i < 100; i++) begin
        if (i == 0) begin
            out_any[i] = 1'b0; // no neighbor to the right for in[0]
        end else begin
            out_any[i] = in[i] | in[i - 1];
        end
    end
end

// out_different: Each bit indicates whether the corresponding input bit is different from its neighbor to the left, wrapping around
always @(*) begin
    for (int i = 0; i < 100; i++) begin
        if (i == 0) begin
            out_different[i] = in[i] ^ in[99]; // wrap around for in[0]
        end else begin
            out_different[i] = in[i] ^ in[i - 1];
        end
    end
end

endmodule