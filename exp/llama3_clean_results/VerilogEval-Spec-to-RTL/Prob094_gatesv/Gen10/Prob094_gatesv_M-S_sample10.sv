module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    always @(*) begin
        // out_both
        for (int i = 0; i < 3; i++) begin
            out_both[i] = in[i] & in[i+1];
        end
        out_both[3] = 1'b0; // Since in[3] has no neighbor to the left

        // out_any
        for (int i = 1; i < 4; i++) begin
            out_any[i] = in[i] | in[i-1];
        end
        out_any[0] = in[0]; // Since in[0] has no neighbor to the right

        // out_different
        for (int i = 0; i < 4; i++) begin
            out_different[i] = in[i] ^ in[(i+1) % 4];
        end
    end

endmodule