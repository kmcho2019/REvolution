module TopModule(
    input  [3:0] in,
    output reg [3:0] out_both,
    output reg [3:0] out_any,
    output reg [3:0] out_different
);

    integer i;
    always @(*) begin
        // Default assignments to zero for bits without neighbors
        out_both = 4'b0000;
        out_any = 4'b0000;
        out_different = 4'b0000;

        // Assign bits with neighbors inside loop: bits 0..2 for out_both and out_different
        for (i = 0; i < 3; i = i + 1) begin
            out_both[i] = in[i] & in[i+1];   // neighbor to left is i+1
            out_any[i+1] = in[i+1] | in[i]; // neighbor to right for i+1 is i
            out_different[i] = in[i] ^ in[i+1]; // neighbor to left for out_different (no wrap here)
        end

        // Boundary bits handled explicitly:
        out_both[3] = 1'b0;               // no left neighbor for MSB
        out_any[0] = 1'b0;                // no right neighbor for LSB
        out_different[3] = in[3] ^ in[0]; // wrap-around neighbor for bit 3
    end

endmodule