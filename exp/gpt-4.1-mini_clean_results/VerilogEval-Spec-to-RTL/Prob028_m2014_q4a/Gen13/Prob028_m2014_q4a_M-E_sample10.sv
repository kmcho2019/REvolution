module TopModule(
    input  d,
    input  ena,
    output reg q
);
    always @(*) begin
        if (ena)
            q = d;
        // else retain q (no assignment means latch behavior)
    end
endmodule