module TopModule(
    input d,
    input ena,
    output reg q
);

always @(*) begin
    if (ena)
        q = d;
    // else q retains previous value (no assignment needed)
end

endmodule