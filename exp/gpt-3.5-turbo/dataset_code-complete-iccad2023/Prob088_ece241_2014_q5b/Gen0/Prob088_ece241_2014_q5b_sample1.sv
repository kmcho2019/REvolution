module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

// Define states using one-hot encoding
parameter A = 2'b01;
parameter B = 2'b10;
reg [1:0] state, next_state;

// State transition and output logic
always @ (posedge clk or posedge areset) begin
  if (areset) begin
    state <= A;
  end else begin
    state <= next_state;
  end
end

always_comb begin
  case (state)
    A: begin
      if (x) begin
        z = 1;
        next_state = B;
      end else begin
        z = 0;
        next_state = A;
      end
    end
    B: begin
      if (x) begin
        z = 0;
        next_state = B;
      end else begin
        z = 1;
        next_state = B;
      end
    end
    default: begin
      z = 0;
      next_state = A;
    end
  endcase
end

endmodule