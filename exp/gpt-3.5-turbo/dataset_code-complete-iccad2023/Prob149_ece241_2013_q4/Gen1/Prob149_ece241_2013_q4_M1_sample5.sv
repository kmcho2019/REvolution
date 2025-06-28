module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  // Define states for the state machine
  parameter IDLE = 3'b000, ABOVE_S3 = 3'b001, BETWEEN_S3_S2 = 3'b010, BETWEEN_S2_S1 = 3'b011;
  reg [2:0] state, next_state;

  // Initialize state and outputs
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
    case(state)
      IDLE: next_state = (s == 3'b011) ? ABOVE_S3 : IDLE;
      ABOVE_S3: next_state = (s == 3'b011) ? ABOVE_S3 : (s == 3'b010) ? BETWEEN_S3_S2 : IDLE;
      BETWEEN_S3_S2: next_state = (s == 3'b011) ? ABOVE_S3 : (s == 3'b010) ? BETWEEN_S3_S2 : (s == 3'b001) ? BETWEEN_S2_S1 : IDLE;
      BETWEEN_S2_S1: next_state = (s == 3'b011) ? ABOVE_S3 : (s == 3'b010) ? BETWEEN_S3_S2 : (s == 3'b001) ? BETWEEN_S2_S1 : IDLE;
      default: next_state = IDLE;
    endcase
  end

endmodule