module TopModule (
    input d,
    input ena,
    output reg q
);

always @ (d or ena) begin
    if (ena)
        q = d;
    // else q holds its value (latch behavior)
end

endmodule