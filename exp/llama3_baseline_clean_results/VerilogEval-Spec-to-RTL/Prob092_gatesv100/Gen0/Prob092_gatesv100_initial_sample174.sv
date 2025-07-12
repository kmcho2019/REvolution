module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Generate out_both: Each bit indicates if the corresponding input bit and its neighbour to the left are '1'.
    // Since in[99] has no neighbour to the left, out_both[99] is always 0.
    assign out_both[99] = 1'b0;
    for (genvar i = 98; i >= 0; i--) begin
        assign out_both[i] = in[i] & in[i+1];
    end

    // Generate out_any: Each bit indicates if any of the corresponding input bit and its neighbour to the right are '1'.
    // Since in[0] has no neighbour to the right, out_any[0] is always 0.
    assign out_any[0] = 1'b0;
    for (genvar i = 1; i <= 99; i++) begin
        assign out_any[i] = in[i] | in[i-1];
    end

    // Generate out_different: Each bit indicates if the corresponding input bit is different from its neighbour to the left.
    // For this part, treat the vector as wrapping around, so in[99]'s neighbour to the left is in[0].
    for (genvar i = 0; i <= 99; i++) begin
        assign out_different[i] = in[i] ^ in[(i+1)%100];
    end

endmodule