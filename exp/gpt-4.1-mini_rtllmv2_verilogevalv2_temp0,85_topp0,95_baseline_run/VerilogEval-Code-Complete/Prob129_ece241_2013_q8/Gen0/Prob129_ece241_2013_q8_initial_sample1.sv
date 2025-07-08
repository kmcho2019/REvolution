module TopModule (
  input clk,
  input aresetn,
  input x,
  output reg z
);

  typedef enum logic [1:0] {
    S0 = 2'b00, // no match
    S1 = 2'b01, // matched '1'
    S2 = 2'b10  // matched '10'
  } state_t;

  state_t state, next_state;

  // State register with negative edge asynchronous reset
  always @(negedge aresetn or posedge clk) begin
    if (!aresetn)
      state <= S0;
    else
      state <= next_state;
  end

  // Next state logic and output logic
  always @(*) begin
    z = 1'b0;
    case (state)
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
          z = 1'b1; // sequence "101" detected here
        end else
          next_state = S0;
      end
      default: next_state = S0;
    endcase
  end

endmodule