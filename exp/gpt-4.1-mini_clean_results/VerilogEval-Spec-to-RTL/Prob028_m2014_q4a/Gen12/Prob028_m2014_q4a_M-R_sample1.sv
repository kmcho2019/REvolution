module TopModule(
    input d,
    input ena,
    output reg q
);

    always @(ena or d) begin
        if (ena)
            q = d;  // blocking assignment for latch inference
    end

endmodule