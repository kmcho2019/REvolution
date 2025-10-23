module TopModule (
  input  clk,
  input  areset,
  input  in,
  output out
);

// Define the states
enum logic [0:0] {
  A = 1'b0,
  B = 1'b1
} state, next_state;

// Asynchronous reset
always @(posedge areset or posedge clk) begin
  if (areset) begin
    state <= B;
  end else begin
    case (state)
      A: begin
        if (~in) begin
          next_state <= B;
        end else begin
          next_state <= A;
        end
      end
      B: begin
        if (in) begin
          next_state <= B;
        end else begin
          next_state <= A;
        end
      end
    endcase
    state <= next_state;
  end
end

// Output logic
assign out = ~state;  // State A is represented by 0 and state B by 1

endmodule