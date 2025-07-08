module TopModule (
  input clk,
  input aresetn,
  input x,
  output reg z
);

  // State encoding
  typedef enum reg [1:0] {
    S0 = 2'b00,
    S1 = 2'b01,
    S2 = 2'b10
  } state_t;

  reg [1:0] state, next_state;

  // State transition - sequential logic with async negative edge reset
  always @(posedge clk or negedge aresetn) begin
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
        if (!x)
          next_state = S2;
        else
          next_state = S1;
      end
      S2: begin
        if (x) begin
          next_state = S1;
          z = 1'b1; // Sequence "101" detected
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