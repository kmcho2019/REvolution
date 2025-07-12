module TopModule(
  input  clk,
  input  areset,
  input  j,
  input  k,
  output out
);

// Define states as enums
enum logic [0:0] {OFF, ON} state, next_state;

// Output logic
always_comb begin
  case(state)
    OFF: out = 1'b0;
    ON:  out = 1'b1;
  endcase
end

// Next state logic
always_comb begin
  case(state)
    OFF: begin
      if (j == 1'b1) begin
        next_state = ON;
      end else begin
        next_state = OFF;
      end
    end
    ON: begin
      if (k == 1'b1) begin
        next_state = OFF;
      end else begin
        next_state = ON;
      end
    end
  endcase
end

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= OFF;
  end else begin
    state <= next_state;
  end
end

endmodule