module TopModule(
  input  clk,
  input  reset,
  input  in,
  output out
);

typedef enum logic [0:0] {B, A} state;

state current_state, next_state;

always_comb begin
  case (current_state)
    B: next_state = in ? B : A;
    A: next_state = in ? A : B;
    default: next_state = B; // default to state B
  endcase
end

always_ff @(posedge clk) begin
  if (reset) begin
    current_state <= B;
    out <= 1'b1;
  end else begin
    current_state <= next_state;
    case (next_state)
      B: out <= 1'b1;
      A: out <= 1'b0;
      default: out <= 1'b1; // default to out=1
    endcase
  end
end

endmodule