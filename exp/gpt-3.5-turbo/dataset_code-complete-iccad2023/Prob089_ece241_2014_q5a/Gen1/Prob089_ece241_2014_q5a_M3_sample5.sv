module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

// State declaration
parameter WAIT = 2'b00;
parameter ADD1 = 2'b01;
reg [1:0] state, next_state;
reg [7:0] shift_reg;

always @ (posedge clk or posedge areset) begin
  if (areset) begin
    state <= WAIT;
    shift_reg <= 8'b0;
    z <= 0;
  end
  else begin
    state <= next_state;
    case(state)
      WAIT: begin
        if (~x) begin
          next_state <= ADD1;
          shift_reg <= {shift_reg[6:0], x};
        end
        else begin
          next_state <= WAIT;
        end
      end
      ADD1: begin
        next_state <= WAIT;
        z <= ~{1'b0, shift_reg} + 1;
      end
    endcase
  end
end

endmodule