module TopModule (
  input clk,
  input aresetn,
  input x,
  output reg z
);

  // State encoding
  typedef enum reg [1:0] {
    S0 = 2'b00, // initial state, no match
    S1 = 2'b01, // matched '1'
    S2 = 2'b10  // matched '10'
  } state_t;

  state_t state, next_state;

  // Sequential logic with asynchronous negative-edge reset
  always @(negedge aresetn or posedge clk) begin
    if (!aresetn)
      state <= S0;
    else
      state <= next_state;
  end

  // Next state logic and output logic (Mealy)
  always @(*) begin
    z = 1'b0; // default output
    case(state)
      S0: begin
        if (x)
          next_state = S1;
        else
          next_state = S0;
      end
      S1: begin
        if (x)
          next_state = S1; // still matched '1'
        else
          next_state = S2; // matched '10'
      end
      S2: begin
        if (x) begin
          next_state = S1;
          z = 1'b1; // "101" detected on this input
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