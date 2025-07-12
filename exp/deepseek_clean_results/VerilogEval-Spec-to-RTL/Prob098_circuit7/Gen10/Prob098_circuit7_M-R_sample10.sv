module TopModule (
    input clk,
    input a,
    output q
);

wire d;
reg q_reg;

assign d = ~a;

always @(posedge clk) begin
    q_reg <= d;
end

assign q = q_reg;

endmodule