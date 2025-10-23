module TopModule (
    input d,
    input ena,
    output reg q
);

always @(d or ena) begin
    if (ena) begin
        q <= d;  // Transparent mode - pass input to output
    end
    // Else implicitly retain previous value (latch behavior)
end

endmodule