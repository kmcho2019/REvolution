module TopModule (
    input clk,
    input a,
    output q
);

wire d;
reg q_reg;

assign d = ~a;  // Combinational inversion
assign q = q_reg;  // Output assignment

always @(posedge clk) begin
    q_reg <= d;  // Sequential element
end

endmodule