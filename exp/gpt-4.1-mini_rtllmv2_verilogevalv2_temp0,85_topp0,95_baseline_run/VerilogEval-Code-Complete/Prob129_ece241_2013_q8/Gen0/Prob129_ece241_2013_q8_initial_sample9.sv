module TopModule (
  input clk,
  input aresetn,
  input x,
  output reg z
);

  typedef enum reg [1:0] {S0 = 2'b00, S1 = 2'b01, S2 = 2'b10} state_t;
  state_t state, next_state;

  // Asynchronous negative edge reset and synchronous state update
  always @(negedge aresetn or posedge clk) begin
    if (~aresetn)
      state <= S0;
    else
      state <= next_state;
  end

  // Next state logic and output logic (Mealy machine)
  always @(*) begin
    // Default assignments
    next_state = state;
    z = 0;

    case(state)
      S0: begin
        if (x)       // input=1: detected first '1'
          next_state = S1;
        else
          next_state = S0;
      end
      S1: begin
        if (~x)      // input=0: detected '10'
          next_state = S2;
        else         // input=1: still detected '1' so stay in S1
          next_state = S1;
      end
      S2: begin
        if (x) begin // input=1: completes "101"
          z = 1;
          next_state = S1; // because the last input is '1', possible start of new sequence
        end
        else begin
          next_state = S0;
        end
      end
    endcase
  end

endmodule