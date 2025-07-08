module TopModule (
    input d,
    input ena,
    output reg q
);

always @(*) begin
    if (ena)
        q = d;
    // else q retains its value (no else block needed since q is reg)
end

endmodule