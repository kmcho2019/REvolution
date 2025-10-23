module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

always @(*) begin
    // Initialize output vectors
    out_both = 4'b0000;
    out_any = 4'b0000;
    out_different = 4'b0000;

    // Iterate through each bit of the input vector
    for (int i = 0; i < 4; i++) begin
        // Calculate index of neighbor to the left, considering wrap-around
        int left_idx = (i == 0)? 3 : i - 1;

        // Calculate index of neighbor to the right, considering wrap-around
        int right_idx = (i == 3)? 0 : i + 1;

        // Assign out_both
        if (i < 3) begin
            out_both[i] = (in[i] == 1'b1 && in[left_idx] == 1'b1)? 1'b1 : 1'b0;
        end

        // Assign out_any
        if (i > 0) begin
            out_any[i] = (in[i] == 1'b1 || in[right_idx] == 1'b1)? 1'b1 : 1'b0;
        end

        // Assign out_different
        out_different[i] = (in[i]!= in[left_idx])? 1'b1 : 1'b0;
    end
end

endmodule