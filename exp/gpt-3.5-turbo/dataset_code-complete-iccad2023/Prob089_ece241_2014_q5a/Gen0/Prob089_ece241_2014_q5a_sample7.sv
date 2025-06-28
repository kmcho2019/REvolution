module Moore2sComplement (
  input clk,
  input areset,
  input x,
  output reg z
);

  // State declaration
  reg [1:0] state;
  parameter WAIT = 2'b00, CONVERT = 2'b01;

  // Complement calculation logic
  always @ (posedge clk or negedge areset)
  begin
    if (!areset)
    begin
      state <= WAIT;
      z <= 0;
    end
    else
    begin
      case (state)
        WAIT: begin
          if (areset == 0)
            state <= CONVERT;
        end
        CONVERT: begin
          z <= (x == 1) ? ~z + 1 : z; // 2's complement calculation
          if (areset == 1)
            state <= WAIT;
        end
      endcase
    end
  end

endmodule