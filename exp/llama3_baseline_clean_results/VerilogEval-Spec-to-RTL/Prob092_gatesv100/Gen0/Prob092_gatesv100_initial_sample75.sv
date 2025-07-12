module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    always @(*) begin
        for (int i = 0; i < 100; i++) begin
            // For out_both, check if current bit and its left neighbor are both '1'
            if (i == 99) begin
                out_both[i] = 0; // No left neighbor for in[99]
            end else begin
                out_both[i] = in[i] & in[i + 1];
            end

            // For out_any, check if current bit or its right neighbor is '1'
            if (i == 0) begin
                out_any[i] = 0; // No right neighbor for in[0]
            end else begin
                out_any[i] = in[i] | in[i - 1];
            end

            // For out_different, check if current bit is different from its left neighbor
            if (i == 0) begin
                out_different[i] = in[i] ^ in[99]; // Wrap around to the start of the vector
            end else begin
                out_different[i] = in[i] ^ in[i - 1];
            end
        end
    end

endmodule