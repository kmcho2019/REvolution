module TopModule (
    input clk,
    input d,
    output q
);

reg q_reg;

// Clock-gated assignment: when clk is high, pass d; otherwise hold value
assign q = clk ? d : q_reg;

always @(posedge clk) begin
    q_reg <= d;
end

endmodule