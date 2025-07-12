module TopModule(
    input d,
    input ena,
    output reg q
);
    // Synthesis directive for latch inference (optional depending on tool)
    // synthesis syn_latch_enable = 1

    always @(ena or d) begin
        if (ena)
            q <= d;
        else
            q <= q; // hold previous value explicitly
    end
endmodule