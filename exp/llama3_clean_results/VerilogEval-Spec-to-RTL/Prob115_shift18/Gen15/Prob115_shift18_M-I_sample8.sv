module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output [63:0] q
);

reg [63:0] q_reg;

wire [63:0] shift_left_1;
wire [63:0] shift_left_8;
wire [63:0] shift_right_1;
wire [63:0] shift_right_8;

assign shift_left_1 = {q_reg[62:0], 1'b0};
assign shift_left_8 = {q_reg[55:0], 8'b0};
assign shift_right_1 = {{63{q_reg[63]}}, q_reg[63:1]};
assign shift_right_8 = {{56{q_reg[63]}}, q_reg[63:8]};

wire [63:0] next_q;

assign next_q = (load)? data :
                 (ena)? (
                   (amount == 2'b00)? shift_left_1 :
                   (amount == 2'b01)? shift_left_8 :
                   (amount == 2'b10)? shift_right_1 :
                   (amount == 2'b11)? shift_right_8 :
                   q_reg
                 ) :
                 q_reg;

always @(posedge clk) begin
  if (ena || load) begin
    q_reg <= next_q;
  end
end

assign q = q_reg;

endmodule