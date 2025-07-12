module TopModule (
    input d,
    input ena,
    output reg q
);

always @(*) begin
    if (ena) q = d;  // Transparent when enabled
    // Else q holds its value (implicit in Verilog)
end

endmodule