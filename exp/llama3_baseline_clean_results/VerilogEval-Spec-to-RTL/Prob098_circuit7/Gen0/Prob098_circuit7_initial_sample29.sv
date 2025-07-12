module TopModule(
    input clk,
    input a,
    output q
);

reg q_reg;

always @(posedge clk) begin
    q_reg <= ~a; // Invert the input a and assign it to q_reg
end

assign q = q_reg; // Assign the value of q_reg to the output q

endmodule