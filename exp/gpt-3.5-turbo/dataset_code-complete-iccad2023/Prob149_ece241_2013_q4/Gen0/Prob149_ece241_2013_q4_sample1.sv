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
  
  // Initialize state and flow rates
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      fr3 <= 1'b1;
      fr2 <= 1'b1;
      fr1 <= 1'b1;
      dfr <= 1'b0;
    end else begin
      state <= next_state;
      case(state)
        IDLE: begin
          fr3 <= 1'b1;
          fr2 <= 1'b1;
          fr1 <= 1'b1;
          dfr <= 1'b0;
        end
        ABOVE_S3: begin
          fr3 <= 1'b1;
          fr2 <= 1'b1;
          fr1 <= 1'b1;
          dfr <= 1'b0;
        end
        BETWEEN_S3_S2: begin
          fr3 <= 1'b0;
          fr2 <= 1'b1;
          fr1 <= 1'b1;
          dfr <= 1'b0;
        end
        BETWEEN_S2_S1: begin
          fr3 <= 1'b0;
          fr2 <= 1'b0;
          fr1 <= 1'b1;
          dfr <= 1'b1;
        end
      endcase
    end
  end

  // Determine next state based on sensor input
  always @(s) begin
    case({s, state})
      3'b011: next_state = ABOVE_S3;
      3'b010: next_state = BETWEEN_S3_S2;
      3'b001: next_state = BETWEEN_S2_S1;
      3'b000: next_state = IDLE;
      default: next_state = IDLE;
    endcase
  end

endmodule