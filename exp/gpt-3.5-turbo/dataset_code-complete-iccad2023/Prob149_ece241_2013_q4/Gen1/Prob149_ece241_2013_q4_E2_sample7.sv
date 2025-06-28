module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  // State machine states
  parameter IDLE = 2'b00, ABOVE_S3 = 2'b01, BETWEEN_S3_S2 = 2'b10, BETWEEN_S2_S1 = 2'b11;
  reg [1:0] state, next_state;
  
  // Initialize state, flow rates, and dfr
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      fr3 <= 1'b1;
      fr2 <= 1'b1;
      fr1 <= 1'b1;
      dfr <= 1'b1; // Ensure dfr is initially open
    end else begin
      state <= next_state;
    end
  end

  // Determine next state based on sensor input
  always @* begin
    case({s, state})
      4'b0111: next_state = ABOVE_S3;
      4'b0110: next_state = BETWEEN_S3_S2;
      4'b0100: next_state = ABOVE_S3; // Transition from S2 to S1 should not happen, keep above S3
      4'b0010: next_state = BETWEEN_S2_S1;
      4'b0000: next_state = IDLE;
      default: next_state = IDLE;
    endcase
  end

  // Update flow rates and dfr based on current state
  always @* begin
    case(state)
      IDLE: begin
        fr3 = 1'b1; fr2 = 1'b1; fr1 = 1'b1; dfr = 1'b1;
      end
      ABOVE_S3: begin
        fr3 = 1'b0; fr2 = 1'b0; fr1 = 1'b0; dfr = 1'b0;
      end
      BETWEEN_S3_S2: begin
        fr3 = 1'b0; fr2 = 1'b1; fr1 = 1'b1; dfr = 1'b0;
      end
      BETWEEN_S2_S1: begin
        fr3 = 1'b0; fr2 = 1'b0; fr1 = 1'b1; dfr = (state == BETWEEN_S3_S2 && s[1]) ? 1'b1 : 1'b0;
      end
    endcase
  end

endmodule