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
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end

  always @(s, state) begin
    case(state)
      IDLE: begin
        fr3 <= 1'b1;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        dfr <= 1'b1;
        if (s[3]) next_state = ABOVE_S3;
        else if (s[2]) next_state = BETWEEN_S3_S2;
        else if (s[1]) next_state = BETWEEN_S2_S1;
        else next_state = IDLE;
      end
      ABOVE_S3: begin
        fr3 <= 1'b1;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        dfr <= 1'b0;
        if (!s[3]) next_state = IDLE;
      end
      BETWEEN_S3_S2: begin
        fr3 <= 1'b0;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        dfr <= 1'b0;
        if (s[3]) next_state = ABOVE_S3;
        else if (!s[2]) next_state = IDLE;
      end
      BETWEEN_S2_S1: begin
        fr3 <= 1'b0;
        fr2 <= 1'b0;
        fr1 <= 1'b1;
        dfr <= 1'b1;
        if (s[2]) next_state = BETWEEN_S3_S2;
        else if (!s[1]) next_state = IDLE;
      end
    endcase
  end

endmodule