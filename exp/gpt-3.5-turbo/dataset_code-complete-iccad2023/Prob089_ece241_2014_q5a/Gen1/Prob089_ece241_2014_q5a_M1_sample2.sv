module TopModule (
  input clk,
  input areset,
  input x,
  output reg [7:0] z
);

parameter STATE_IDLE = 2'b00;
parameter STATE_CONVERTING = 2'b01;
parameter STATE_DONE = 2'b10;

reg [1:0] state;

reg [7:0] complement_temp; // Stores the 2's complement temporarily
reg [2:0] counter; // Counter to keep track of bit position in the input

always @ (posedge clk or posedge areset)
begin
  if (areset)
  begin
    state <= STATE_IDLE;
    z <= 8'b0;
    counter <= 0;
  end
  else
  begin
    case (state)
      STATE_IDLE:
        begin
          if (x) // Wait for the start of conversion
            state <= STATE_CONVERTING;
        end
      STATE_CONVERTING:
        begin
          complement_temp <= (~x) + 1; // Calculate 2's complement

          if (counter < 8) // Calculate until 8 bits processed
          begin
            z <= {complement_temp[counter], z[7:1]}; // Shift existing bits left and append new complement bit
            counter <= counter + 1;
          end
          else
          begin
            state <= STATE_DONE; // Return to idle state after conversion
            counter <= 0;
          end
        end
      STATE_DONE:
        begin
          if (x) // Wait for the start of next conversion
          begin
            state <= STATE_CONVERTING;
            z <= 8'b0;
          end
        end
    endcase
  end
end
endmodule