module TopModule (
    input  clk,
    input  ar,    // Active-high async reset
    input  d,
    output q
);

reg q_reg;

// Continuous assignment for output
assign q = q_reg;

// Flip-flop behavior using continuous assignment
always @(posedge clk or posedge ar) begin
    q_reg <= ar ? 1'b0 : d;
end

endmodule