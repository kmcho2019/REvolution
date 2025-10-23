module TopModule (
    input d,
    input ena,
    output reg q
);

always @(*) begin
    if (ena) q = d;
    // else q retains its value (implicit latch behavior)
end

endmodule