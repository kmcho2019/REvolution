module TopModule(
    input d,
    input ena,
    output reg q
);

always @ (d or ena) begin
    if (ena)
        q = d;
    // else retain previous q value (no change)
end

endmodule