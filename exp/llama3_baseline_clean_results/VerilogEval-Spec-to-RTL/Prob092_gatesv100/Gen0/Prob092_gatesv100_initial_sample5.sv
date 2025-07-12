module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Loop through the input vector to generate out_both
    always @(*) begin
        out_both[99] = 1'b0; // Since in[99] has no neighbour to the left
        for (int i = 98; i >= 0; i--) begin
            out_both[i] = in[i] & in[i + 1];
        end
    end

    // Loop through the input vector to generate out_any
    always @(*) begin
        out_any[0] = 1'b0; // Since in[0] has no neighbour to the right
        for (int i = 1; i <= 99; i++) begin
            out_any[i] = in[i] | in[i - 1];
        end
    end

    // Loop through the input vector to generate out_different
    always @(*) begin
        for (int i = 0; i <= 98; i++) begin
            out_different[i] = in[i] ^ in[i + 1];
        end
        out_different[99] = in[99] ^ in[0]; // Wrap around to the start of the vector
    end

endmodule