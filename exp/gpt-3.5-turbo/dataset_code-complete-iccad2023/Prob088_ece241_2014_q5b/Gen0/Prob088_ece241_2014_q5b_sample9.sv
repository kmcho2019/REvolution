module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

// State encoding
parameter A = 2'b01;
parameter B = 2'b10;

// State flip-flops
reg [1:0] current_state, next_state;

always @(posedge clk or posedge areset) begin
  if (areset) begin
    current_state <= A; // Reset to state A
    z <= 0; // Output z is 0 in state A
  end
  else begin
    current_state <= next_state;
    case (current_state)
      A: begin
        if (x) next_state <= B;
        else next_state <= A;
      end
      B: begin
        if (x) next_state <= B;
        else next_state <= A;
      end
    endcase
  end
end

// Output z logic
always @(*) begin
  case (current_state)
    A: z = 1;
    B: z = 0;
  endcase
end

endmodule