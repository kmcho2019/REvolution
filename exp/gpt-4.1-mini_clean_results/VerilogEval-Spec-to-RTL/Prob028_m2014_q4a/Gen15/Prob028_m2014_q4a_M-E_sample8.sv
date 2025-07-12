module TopModule(
    input wire d,
    input wire ena,
    output wire q
);
    reg latch_q;

    always @(ena or d) begin
        if (ena)
            latch_q = d;
        // else retain latch_q (latch behavior)
    end

    assign q = latch_q;

endmodule