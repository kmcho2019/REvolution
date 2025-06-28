module TopModule (
  input clk,
  input aresetn,
  input x,
  output reg z
);

  // Define the states
  typedef enum logic [1:0] {
    S0,
    S1,
    S2
  } state_type;

  // Declare state and next_state
  state_type state, next_state;

  // Define parameters for the states
  parameter S0_DELAY = 2'd0, S1_DELAY1 = 2'd1, S1_DELAY2 = 2'd2, S2_DELAY = 2'd3;

  // Define the state register
  always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
      state <= S0;
      z <= 0;
    end
    else begin
      state <= next_state;
    end
  end

  // Define the next state and output logic
  always @* begin
    next_state = state;
    z = 0;

    case (state)
      S0: begin
        if (x)
          next_state = S1;
      end

      S1: begin
        if (x)
          next_state = S1;
        else
          next_state = S0;

        if (x && (state == S0))
          next_state = S2;
      end

      S2: begin
        if (x)
          next_state = S1;
          
        z = 1;
      end
    endcase
  end
endmodule