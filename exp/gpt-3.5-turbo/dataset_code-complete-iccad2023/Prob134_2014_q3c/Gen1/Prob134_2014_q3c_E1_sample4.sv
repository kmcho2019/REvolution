module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

// State machine for Y[0]
reg [2:0] state_reg, next_state_Y0;

always @ (posedge clk) begin
  case (state_reg)
    3'b000: next_state_Y0 <= x ? 3'b001 : 3'b000;
    3'b001: next_state_Y0 <= x ? 3'b100 : 3'b001;
    3'b010: next_state_Y0 <= x ? 3'b001 : 3'b010;
    3'b011: next_state_Y0 <= x ? 3'b010 : 3'b001;
    3'b100: next_state_Y0 <= x ? 3'b100 : 3'b011;
    default: next_state_Y0 <= 3'b000;
  endcase
end

always @ (posedge clk) begin
  state_reg <= next_state_Y0;
end

always @* begin
  case(state_reg)
    3'b000: Y0 = 1'b0;
    3'b001: Y0 = 1'b0;
    3'b010: Y0 = 1'b0;
    3'b011: Y0 = 1'b0;
    3'b100: Y0 = 1'b1;
    default: Y0 = 1'b0;
  endcase
end

// Combinational logic for z based on present state y[2:0]
always @* begin
  case(y)
    3'b011: z = 1'b1;
    3'b100: z = 1'b1;
    default: z = 1'b0;
  endcase
end

endmodule