module TopModule (
    input d,
    input ena,
    output reg q
);

always @*
    if (ena) q = d;  // Explicit latch implementation that synthesis tools recognize well

endmodule