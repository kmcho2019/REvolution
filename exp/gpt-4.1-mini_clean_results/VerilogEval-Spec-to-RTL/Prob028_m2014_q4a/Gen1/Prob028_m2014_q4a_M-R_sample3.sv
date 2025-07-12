module TopModule(
    input d,
    input ena,
    output reg q
);

always @(*) begin
    if (ena)
        q <= d;
    // else retain previous q (latch behavior)
end

endmodule