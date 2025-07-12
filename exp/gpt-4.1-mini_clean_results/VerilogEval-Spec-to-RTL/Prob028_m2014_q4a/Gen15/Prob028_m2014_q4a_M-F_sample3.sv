module TopModule(
    input  d,
    input  ena,
    output reg q
);

    always @(d or ena) begin
        if (ena)
            q = d;  // blocking assignment for latch inference
        // else hold the previous value of q (latch inferred)
    end

endmodule