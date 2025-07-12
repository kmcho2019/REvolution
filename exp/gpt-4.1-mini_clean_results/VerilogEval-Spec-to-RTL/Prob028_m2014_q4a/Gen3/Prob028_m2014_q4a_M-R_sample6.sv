module TopModule(
    input d,
    input ena,
    output reg q
);

always @(ena or d) begin
    if (ena)
        q <= d;  // Nonblocking assignment to model latch transparency
    // else retain previous q (latch behavior)
end

endmodule