module TopModule(
    input  d,
    input  ena,
    output reg q
);
    always @(ena or d) begin
        if (ena)
            q <= d;
        // else retain q (latch behavior)
    end
endmodule