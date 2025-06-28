module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);

reg [15:0] q_next;
reg [15:0] q_reg;
reg [3:0] q_temp;

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    q_reg <= 16'd0;
    ena <= 3'b0;
  end else begin
    q_reg <= q_next;
    ena <= ena;
  end
end

always @* begin
  q_next = q_reg;
  if (ena[0]) q_temp[0] = (q_reg[3:0] == 4'b1001) ? 4'b0000 : q_reg[3:0] + 4'b0001;
  else q_temp[0] = q_reg[3:0];

  if (ena[1]) q_temp[1] = (q_reg[7:4] == 4'b1001) ? {q_reg[11:8], 4'b0000} : {q_reg[11:8], q_reg[7:4] + 4'b0001};
  else q_temp[1] = q_reg[7:4];

  if (ena[2]) q_temp[2] = (q_reg[11:8] == 4'b1001) ? {q_reg[15:12], 4'b0000} : {q_reg[15:12], q_reg[11:8] + 4'b0001};
  else q_temp[2] = q_reg[11:8];

  if (ena[3]) q_temp[3] = (q_reg[15:12] == 4'b1001) ? {4'b0000, q_reg[15:12]} : q_reg[15:12] + 4'b0001;
  else q_temp[3] = q_reg[15:12];

  q_next = {q_temp[3], q_temp[2], q_temp[1], q_temp[0]};
end

assign q = q_reg;

endmodule