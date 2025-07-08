module TopModule (
  input clk,
  input aresetn,
  input x,
  output reg z
);

  // State encoding
  typedef enum reg [1:0] {
    S0 = 2'd0, // no matched bits yet
    S1 = 2'd1, // matched '1'
    S2 = 2'd2  // matched '10'
  } state_t;

  state_t state, next_state;

  // State register with asynchronous negative edge reset
  always @(negedge aresetn or posedge clk) begin
    if (!aresetn)
      state <= S0;
    else
      state <= next_state;
  end

  // Next state logic and output logic (Mealy)
  always @(*) begin
    z = 1'b0; // default output
    case (state)
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
          z = 1'b1;   // detected "101"
          next_state = S1; // last '1' can start new sequence
        end else begin
          next_state = S0;
        end
      end

      default: begin
        next_state = S0;
      end
    endcase
  end

endmodule