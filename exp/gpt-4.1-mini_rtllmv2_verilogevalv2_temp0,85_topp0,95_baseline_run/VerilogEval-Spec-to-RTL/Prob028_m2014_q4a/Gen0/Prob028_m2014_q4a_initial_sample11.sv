module TopModule (
    input d,
    input ena,
    output reg q
);

always @(*) begin
    if (ena)
        q = d;
    // else q holds its value (no assignment means q keeps previous value)
end

endmodule