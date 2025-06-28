module TopModule (
  input x,
  input y,
  output z
);

  reg [1:0] state; // State variable indicating the value of z
  
  always @ (x, y)
    begin
      case (state)
        2'b01: // z = 01
          begin
            if (x == 1 && y == 0)
              state <= 2'b10; // Transition to z = 10
            else if (x == 1 && y == 1)
              state <= 2'b11; // Transition to z = 11
          end
        2'b10: // z = 10
          begin
            if (x == 0 && y == 1)
              state <= 2'b10; // Transition to z = 10
            else if (x == 1 && y == 1)
              state <= 2'b11; // Transition to z = 11
          end
        2'b11: // z = 11
          begin
            if (x == 0 && y == 0)
              state <= 2'b01; // Transition to z = 01
            else if (x == 0 && y == 1)
              state <= 2'b10; // Transition to z = 10
          end
      endcase
    end

  assign z = state[0]; // Output z based on the LSB of the state variable

endmodule