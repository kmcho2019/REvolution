module TopModule (
    input d,
    input ena,
    output reg q
);

always @(*) begin
    if (ena) q = d;  // Transparent when enabled
    // q retains value when not enabled (implicit)
end

endmodule