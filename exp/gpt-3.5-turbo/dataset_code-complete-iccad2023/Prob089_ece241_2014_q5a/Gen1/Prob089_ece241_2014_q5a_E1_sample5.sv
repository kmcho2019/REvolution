module TopModule (
  input clk,
  input areset,
  input x,
  output reg [7:0] z
);

reg [2:0] state;
parameter STATE_IDLE = 3'b000;
parameter STATE_CONVERTING = 3'b001;

always @ (posedge clk, posedge areset)
begin
  if (areset) begin
    z <= 8'b00000000;
    state <= STATE_IDLE;
  end
  else begin
    case(state)
      STATE_IDLE:
        begin
          if (!areset && x) begin
            z <= 1'b1; // Set LSB of z to 1
            state <= STATE_CONVERTING;
          end
        end
      STATE_CONVERTING:
        begin
          z <= {z[6:0], ~x}; // Shift existing bits left and append inverted x (2's complement)
          if (z[7]) // If MSB of z is 1 (negative number), carry out 2's complement conversion
            z <= z + 1;
          if (z == 8'b11111111) // Stop when all bits are 1 (input=-1)
            state <= STATE_IDLE;
        end
    endcase
  end
end

endmodule