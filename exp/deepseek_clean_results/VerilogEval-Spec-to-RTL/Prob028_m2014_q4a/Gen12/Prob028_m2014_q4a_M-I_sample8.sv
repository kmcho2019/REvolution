module TopModule (
    input d,
    input ena,
    output reg q = 0
);

always_latch begin
    if (ena) q <= d;
end

endmodule