module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

always @(*) begin
    // Initialize out_both, out_any, and out_different
    out_both = 0;
    out_any = 0;
    out_different = 0;

    // Iterate over each bit in the input vector
    for (int i = 0; i < 100; i++) begin
        // Calculate the index of the neighbor to the left
        int left_idx = (i == 99) ? 0 : i + 1;

        // Calculate the index of the neighbor to the right
        int right_idx = (i == 0) ? 99 : i - 1;

        // Check if the current bit and its neighbor to the left are both '1'
        if (in[i] == 1'b1 && in[left_idx] == 1'b1) begin
            out_both[i] = 1'b1;
        end

        // Check if the current bit or its neighbor to the right is '1'
        if (in[i] == 1'b1 || in[right_idx] == 1'b1) begin
            out_any[i] = 1'b1;
        end

        // Check if the current bit is different from its neighbor to the left
        if (in[i] != in[left_idx]) begin
            out_different[i] = 1'b1;
        end
    end
end

endmodule