module TopModule(
    input  d,
    input  ena,
    output reg q
);

    always @(ena or d) begin
        if (ena)
            q <= d;  // transparent latch when ena is high
        // else: q retains previous value (latch inferred)
    end

endmodule