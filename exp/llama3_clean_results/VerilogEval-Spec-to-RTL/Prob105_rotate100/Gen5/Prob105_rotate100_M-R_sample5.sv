module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

always @(posedge clk) begin
    q_reg <= load ? data :
              (ena == 2'b01) ? {q_reg[0], q_reg[99:1]} :
              (ena == 2'b10) ? {q_reg[98:0], q_reg[99]} : q_reg;
end

assign q = q_reg;

endmodule