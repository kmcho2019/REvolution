module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

// State declaration
parameter WAIT = 2'b00;
parameter NEGATE = 2'b01;
reg [1:0] state, next_state;

// Internal signal to store the 2's complement accumulator
reg [7:0] accumulator;

always @ (posedge clk or posedge areset) begin
  if (areset) begin
    state <= WAIT;
    accumulator <= 8'b0;
    z <= 1'b0;
  end
  else begin
    state <= next_state;
    case(state)
      WAIT: begin
        if (~x) begin
          next_state <= NEGATE;
          accumulator <= 1;
        end
        else begin
          next_state <= WAIT;
        end
      end
      NEGATE: begin
        next_state <= WAIT;
        accumulator <= accumulator + x;
        z <= accumulator[7];
        accumulator <= {accumulator[6:0], ~accumulator[7]};
      end
    endcase
  end
end

endmodule