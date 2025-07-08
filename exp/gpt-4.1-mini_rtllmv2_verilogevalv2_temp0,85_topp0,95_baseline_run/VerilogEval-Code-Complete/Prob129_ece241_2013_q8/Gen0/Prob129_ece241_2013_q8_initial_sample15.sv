module TopModule (
  input clk,
  input aresetn,
  input x,
  output reg z
);

  // State encoding
  typedef enum reg [1:0] {
    S0 = 2'd0,
    S1 = 2'd1,
    S2 = 2'd2
  } state_t;

  state_t current_state, next_state;

  // State register with negative edge asynchronous reset
  always @(negedge aresetn or posedge clk) begin
    if (!aresetn)
      current_state <= S0;
    else
      current_state <= next_state;
  end

  // Next state and output logic (Mealy FSM)
  always @(*) begin
    z = 1'b0; // default output
    case (current_state)
      S0: begin
        if (x)
          next_state = S1;
        else
          next_state = S0;
      end
      S1: begin
        if (x)
          next_state = S1;
        else
          next_state = S2;
      end
      S2: begin
        if (x) begin
          next_state = S1;
          z = 1'b1; // sequence "101" detected
        end else
          next_state = S0;
      end
      default: begin
        next_state = S0;
        z = 1'b0;
      end
    endcase
  end

endmodule