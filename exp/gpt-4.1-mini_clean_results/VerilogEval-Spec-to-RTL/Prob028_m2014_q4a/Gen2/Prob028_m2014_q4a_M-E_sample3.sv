module TopModule (
    input  d,
    input  ena,
    output q
);

reg q_reg;

always @(ena or d) begin
    if (ena)
        q_reg <= d;
end

assign q = ena ? d : q_reg;

endmodule