module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

// State register
reg [2:0] state, next_state;

// Output logic
always @*
begin
  case({state, x})
    3'b000_0: begin
      next_state = 3'b000;
      Y0 = 1'b0;
      z = 1'b0;
    end
    3'b001_0: begin
      next_state = 3'b001;
      Y0 = 1'b0;
      z = 1'b0;
    end
    3'b001_1: begin
      next_state = 3'b100;
      Y0 = 1'b1;
      z = 1'b0;
    end
    3'b010_0: begin
      next_state = 3'b001;
      Y0 = 1'b0;
      z = 1'b0;
    end
    3'b011_0: begin
      next_state = 3'b001;
      Y0 = 1'b0;
      z = 1'b1;
    end
    3'b011_1: begin
      next_state = 3'b010;
      Y0 = 1'b0;
      z = 1'b1;
    end
    3'b100_0: begin
      next_state = 3'b011;
      Y0 = 1'b1;
      z = 1'b1;
    end
    3'b100_1: begin
      next_state = 3'b100;
      Y0 = 1'b1;
      z = 1'b1;
    end
    default: begin
      next_state = 3'bxxx; // Next state is undefined
      Y0 = 1'bx; // Output is undefined
      z = 1'bx;  // Output is undefined
    end
  endcase
end

// State transition
always @(posedge clk)
begin
  state <= next_state;
end

endmodule