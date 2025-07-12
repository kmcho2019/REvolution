module TopModule (
    input d,
    input ena,
    output reg q
);

always @(*) begin
    if (ena) begin
        q <= d;
    end
    // else q retains its value (implicit latch behavior)
end

endmodule