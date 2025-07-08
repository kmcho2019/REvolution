module TopModule (
  input clk,
  input aresetn,
  input x,
  output reg z
);

  // Define states as localparams
  localparam [1:0]
    S0 = 2'b00,  // no match
    S1 = 2'b01,  // matched '1'
    S2 = 2'b10;  // matched '10'

  reg [1:0] state, next_state;

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
          next_state = S1;
        else
          next_state = S2;
      end

      S2: begin
        if (x) begin
          z = 1'b1;      // sequence "101" detected
          next_state = S1; // last input '1' can start a new sequence
        end else
          next_state = S0;
      end

      default: begin
        next_state = S0;
      end
    endcase
  end

  // State register with asynchronous negative edge reset
  always @(negedge aresetn or posedge clk) begin
    if (!aresetn)
      state <= S0;
    else
      state <= next_state;
  end

endmodule