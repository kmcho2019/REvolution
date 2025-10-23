module TopModule (
    input d,
    input ena,
    output reg q
);

always @(*) begin
    if (ena) begin
        q = d;
    end
    // Implicit else retains current value (latch behavior)
end

endmodule