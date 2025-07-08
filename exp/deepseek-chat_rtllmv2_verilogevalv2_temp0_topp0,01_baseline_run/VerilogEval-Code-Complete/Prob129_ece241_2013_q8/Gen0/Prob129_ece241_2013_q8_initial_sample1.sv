module TopModule (
  input clk,
  input aresetn,
  input x,
  output reg z
);

  // Define states
  typedef enum logic [1:0] {
    S0,
    S1,
    S2
  } state_t;

  // State registers
  state_t current_state, next_state;

  // State transition and output logic
  always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
      current_state <= S0;
    end else begin
      current_state <= next_state;
    end
  end

  always @(*) begin
    case (current_state)
      S0: begin
        if (x) begin
          next_state = S1;
          z = 0;
        end else begin
          next_state = S0;
          z = 0;
        end
      end
      S1: begin
        if (!x) begin
          next_state = S2;
          z = 0;
        end else begin
          next_state = S1;
          z = 0;
        end
      end
      S2: begin
        if (x) begin
          next_state = S1;
          z = 1;
        end else begin
          next_state = S0;
          z = 0;
        end
      end
      default: begin
        next_state = S0;
        z = 0;
      end
    endcase
  end

endmodule