module TopModule (
    input d,
    input ena,
    output reg q
);

always @(d or ena) begin
    if (ena) q = d;
    // No else branch - q retains value when ena is low
end

endmodule