module TopModule(
    input  d,
    input  ena,
    output reg q
);

    // Level-sensitive D latch using nonblocking assignment for better synthesis compatibility
    always @(ena or d) begin
        if (ena)
            q <= d;
        // else q holds previous value (latch inferred)
    end

endmodule