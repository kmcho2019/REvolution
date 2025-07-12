module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

reg internal_q;

always @(*) begin
    if (ar) internal_q = 0;
    else if (clk) internal_q = d;
    else internal_q = q;
end

assign q = internal_q;

endmodule