module TopModule (
    input d,
    input ena,
    output reg q
);

always @(*) begin
    if (ena) begin
        q = d;
    end
    // Implicit else: q retains its value (latch behavior)
end

endmodule