module TopModule(
    input  d,
    input  ena,
    output reg q
);

    always @(ena or d) begin
        if (ena)
            q = d;    // latch transparent when ena=1
        // else q holds previous value implicitly (latch)
    end

endmodule