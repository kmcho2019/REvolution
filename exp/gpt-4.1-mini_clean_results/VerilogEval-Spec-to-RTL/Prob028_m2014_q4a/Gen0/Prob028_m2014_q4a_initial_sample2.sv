module TopModule (
    input d,
    input ena,
    output reg q
);

always @(*) begin
    if (ena)
        q = d;
    // else retain q (no assignment, so q holds its value)
end

endmodule