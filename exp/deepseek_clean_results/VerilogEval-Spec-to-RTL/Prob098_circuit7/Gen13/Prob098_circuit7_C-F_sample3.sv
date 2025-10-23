module TopModule (
    input clk,
    input a,
    output q
);

reg q_reg;

always @(posedge clk) begin
    q_reg <= ~a;  // Combined inversion and sequential update
end

assign q = q_reg;  // Clean output assignment

endmodule