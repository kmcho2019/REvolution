module TopModule (
    input  d,
    input  ena,
    output q
);

reg q_reg;

assign q = q_reg;

always @(ena or d) begin
    if (ena)
        q_reg = d;  // transparent
    // else q_reg holds its value (latch)
end

endmodule