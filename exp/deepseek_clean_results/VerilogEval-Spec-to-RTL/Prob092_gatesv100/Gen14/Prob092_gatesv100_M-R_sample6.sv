module TopModule (
    input [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different
);

    reg [99:0] in_shifted_left;
    reg [99:0] in_shifted_right;
    reg [99:0] in_shifted_circular;

    always_comb begin
        // Left shift for out_both (bit 99 has no left neighbor)
        in_shifted_left = {in[98:0], 1'b0};
        out_both = in & in_shifted_left;
        out_both[99] = 1'b0;  // Explicit edge case

        // Right shift for out_any (bit 0 has no right neighbor)
        in_shifted_right = {1'b0, in[99:1]};
        out_any = in | in_shifted_right;
        out_any[0] = 1'b0;    // Explicit edge case

        // Circular shift for out_different
        in_shifted_circular = {in[0], in[99:1]};
        out_different = in ^ in_shifted_circular;
    end

endmodule