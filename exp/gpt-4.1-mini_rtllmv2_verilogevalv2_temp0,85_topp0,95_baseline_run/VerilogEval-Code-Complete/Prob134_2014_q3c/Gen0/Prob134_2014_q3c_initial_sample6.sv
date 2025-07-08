module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

  always @(*) begin
    // Default values
    reg [2:0] next_state;
    next_state = 3'b000;
    z = 1'b0;

    // Determine output z from present state y
    case(y)
      3'b000: z = 1'b0;
      3'b001: z = 1'b0;
      3'b010: z = 1'b0;
      3'b011: z = 1'b1;
      3'b100: z = 1'b1;
      default: z = 1'b0;
    endcase

    // Determine next_state from present state y and input x
    case(y)
      3'b000: next_state = (x == 1'b0) ? 3'b000 : 3'b001;
      3'b001: next_state = (x == 1'b0) ? 3'b001 : 3'b100;
      3'b010: next_state = (x == 1'b0) ? 3'b010 : 3'b001;
      3'b011: next_state = (x == 1'b0) ? 3'b001 : 3'b010;
      3'b100: next_state = (x == 1'b0) ? 3'b011 : 3'b100;
      default: next_state = 3'b000;
    endcase

    // Assign Y0 as LSB of next_state
    Y0 = next_state[0];
  end

endmodule