module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

// Define the next state values and outputs based on the state-assigned table
reg [2:0] next_state;
reg next_z;

always @*
begin
  case(y)
    3'b000: begin
      if (x == 0) begin
        next_state = 3'b000;
        next_z = 1'b0;
      end
      else begin
        next_state = 3'b001;
        next_z = 1'b0;
      end
    end
    3'b001: begin
      if (x == 0) begin
        next_state = 3'b001;
        next_z = 1'b0;
      end
      else begin
        next_state = 3'b100;
        next_z = 1'b0;
      end
    end
    3'b010: begin
      if (x == 0) begin
        next_state = 3'b010;
        next_z = 1'b0;
      end
      else begin
        next_state = 3'b001;
        next_z = 1'b0;
      end
    end
    3'b011: begin
      if (x == 0) begin
        next_state = 3'b001;
        next_z = 1'b1;
      end
      else begin
        next_state = 3'b010;
        next_z = 1'b1;
      end
    end
    3'b100: begin
      if (x == 0) begin
        next_state = 3'b011;
        next_z = 1'b1;
      end
      else begin
        next_state = 3'b100;
        next_z = 1'b1;
      end
    end
  endcase
end

// Assign the outputs based on the next state values
always @*
begin
  Y0 = next_state[0];
  z = next_z;
end

endmodule