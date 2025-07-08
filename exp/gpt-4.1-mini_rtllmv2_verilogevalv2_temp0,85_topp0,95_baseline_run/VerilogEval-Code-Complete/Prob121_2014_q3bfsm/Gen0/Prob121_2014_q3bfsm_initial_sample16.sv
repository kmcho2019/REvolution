module TopModule (
  input clk,
  input reset,
  input x,
  output reg z
);

  reg [2:0] state, next_state;

  // State encoding for readability
  localparam S0 = 3'b000;
  localparam S1 = 3'b001;
  localparam S2 = 3'b010;
  localparam S3 = 3'b011;
  localparam S4 = 3'b100;

  // Next state logic
  always @(*) begin
    case(state)
      S0: next_state = (x == 0) ? S0 : S1;
      S1: next_state = (x == 0) ? S1 : S4;
      S2: next_state = (x == 0) ? S2 : S1;
      S3: next_state = (x == 0) ? S1 : S2;
      S4: next_state = (x == 0) ? S3 : S4;
      default: next_state = S0;
    endcase
  end

  // State register with synchronous reset
  always @(posedge clk) begin
    if (reset)
      state <= S0;
    else
      state <= next_state;
  end

  // Output logic
  always @(*) begin
    case(state)
      S3: z = 1;
      S4: z = 1;
      default: z = 0;
    endcase
  end

endmodule