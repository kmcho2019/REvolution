module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

// Define states
parameter IDLE = 2'b00;
parameter FIRST_BYTE = 2'b01;
parameter SECOND_BYTE = 2'b10;

// Registers
reg [1:0] state;

always @ (posedge clk or posedge reset)
begin
  if (reset)
  begin
    state <= IDLE;
    done <= 0;
  end
  else
  begin
    case (state)
      IDLE:
        if (in[3] == 1)
          state <= FIRST_BYTE;
      FIRST_BYTE:
        begin
          if (in[3] == 0)
            state <= IDLE;
          else
            state <= SECOND_BYTE;
        end
      SECOND_BYTE:
        begin
          if (in[3] == 0)
            state <= IDLE;
          else
          begin
            state <= IDLE;
            done <= 1;
          end
        end
    endcase
  end
end

endmodule