module TopModule (
    input  clk,
    input  ar,   // Asynchronous active-high reset
    input  d,
    output     q
);

reg q_reg;

// Clocked process: sample d on positive edge of clk if not in reset
always @(posedge clk) begin
    if (!ar)
        q_reg <= d;
end

// Output logic: asynchronous reset overrides q_reg
assign q = (ar) ? 1'b0 : q_reg;

endmodule