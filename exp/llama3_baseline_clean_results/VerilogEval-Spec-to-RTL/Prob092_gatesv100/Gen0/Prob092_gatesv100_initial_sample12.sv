module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // For out_both, check each bit and its neighbour to the left
    always @(*) begin
        out_both[99] = 1'b0; // MSB has no neighbour to the left
        for (int i = 0; i < 99; i++) begin
            out_both[i] = in[i] && in[i+1];
        end
    end

    // For out_any, check each bit and its neighbour to the right
    always @(*) begin
        out_any[0] = 1'b0; // LSB has no neighbour to the right
        for (int i = 1; i < 100; i++) begin
            out_any[i] = in[i] || in[i-1];
        end
    end

    // For out_different, check each bit and its neighbour to the left, wrapping around
    always @(*) begin
        for (int i = 0; i < 100; i++) begin
            out_different[i] = in[i]!== in[(i+1) % 100];
        end
    end

endmodule