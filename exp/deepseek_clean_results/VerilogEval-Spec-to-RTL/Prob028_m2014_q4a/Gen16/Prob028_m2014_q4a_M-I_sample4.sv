module TopModule (
    input d,
    input ena,
    output reg q
);

always @(ena or d) begin
    if (ena) q = d;
    // q retains value when ena is low - implicit in Verilog
end

endmodule