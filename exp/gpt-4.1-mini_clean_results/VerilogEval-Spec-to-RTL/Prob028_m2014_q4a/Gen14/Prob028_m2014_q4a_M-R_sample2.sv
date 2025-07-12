module TopModule(
    input d,
    input ena,
    output reg q
);
    always @(ena or d) begin
        if (ena)
            q = d;
        // else do nothing, q retains its value (latch behavior)
    end
endmodule