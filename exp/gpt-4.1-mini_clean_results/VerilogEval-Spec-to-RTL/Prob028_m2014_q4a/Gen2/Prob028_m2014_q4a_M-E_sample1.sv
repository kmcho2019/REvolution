module TopModule(
    input d,
    input ena,
    output reg q
);

always @(d or ena) begin
    if (ena)
        q = d;
    // else keep previous q (latch behavior)
end

endmodule