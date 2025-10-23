module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output [63:0] q
);

reg [7:0] q_reg [7:0];

wire [7:0] next_q [7:0];

genvar i;
generate
  for (i = 0; i < 8; i++) begin
    assign next_q[i] = (load)? data[i*8 +: 8] :
                       (ena)? (
                         (amount == 2'b00)? {q_reg[i][6:0], 1'b0} :
                         (amount == 2'b01)? (i > 0)? q_reg[i-1] : 8'b0 :
                         (amount == 2'b10)? {q_reg[i][7], q_reg[i][7:1]} :
                         (amount == 2'b11)? {q_reg[i][7], q_reg[i][7], q_reg[i][7], q_reg[i][7], q_reg[i][7], q_reg[i][7], q_reg[i][7], q_reg[i][7]} :
                         q_reg[i]
                       ) :
                       q_reg[i];
  end
endgenerate

always @(posedge clk) begin
  for (int i = 0; i < 8; i++) begin
    q_reg[i] <= next_q[i];
  end
end

assign q = {q_reg[7], q_reg[6], q_reg[5], q_reg[4], q_reg[3], q_reg[2], q_reg[1], q_reg[0]};

endmodule