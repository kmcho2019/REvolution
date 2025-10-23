module TopModule (
    input clk,
    input a,
    output q
);

reg q_reg;

assign q = (clk && clk) ? ~a : q_reg;  // Clock-gated assignment

always @(posedge clk) begin
    q_reg <= ~a;  // Keep the register to maintain correct timing
end

endmodule