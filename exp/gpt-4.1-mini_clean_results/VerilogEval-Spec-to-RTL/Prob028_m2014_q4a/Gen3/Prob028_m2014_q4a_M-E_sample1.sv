module TopModule(
    input wire d,
    input wire ena,
    output reg q
);

always @(ena) begin
    if (ena)
        q <= d;
    // else retain previous q (latch behavior)
end

endmodule