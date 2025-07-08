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

  state_t state, next_state;

  // State register with asynchronous negative edge reset
  always @(negedge aresetn or posedge clk) begin
    if (!aresetn)
      state <= S0;
    else
      state <= next_state;
  end

  // Next state and output logic
  always @(*) begin
    // Default assignments
    next_state = state;
    z = 1'b0;

    case (state)
      S0: begin
        if (x)
          next_state = S1;
        else
          next_state = S0;
        z = 1'b0;
      end
      S1: begin
        if (!x)
          next_state = S2;
        else
          next_state = S1;
        z = 1'b0;
      end
      S2: begin
        if (x) begin
          next_state = S1;
          z = 1'b1; // sequence "101" detected
        end else begin
          next_state = S0;
          z = 1'b0;
        end
      end
      default: begin
        next_state = S0;
        z = 1'b0;
      end
    endcase
  end

endmodule