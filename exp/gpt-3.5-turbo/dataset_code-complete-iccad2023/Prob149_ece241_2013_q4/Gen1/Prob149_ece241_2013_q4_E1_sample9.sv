module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

// State definitions
parameter IDLE = 2'b00;
parameter ABOVE_S3 = 2'b01;
parameter BETWEEN_S3_S2 = 2'b10;
parameter BETWEEN_S2_S1 = 2'b11;

reg [1:0] state, next_state;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    fr3 <= 1'b0;
    fr2 <= 1'b0;
    fr1 <= 1'b0;
    dfr <= 1'b0;
  end else begin
    state <= next_state;
  end
end

always @* begin
  next_state = state;
  
  case(state)
    IDLE: begin
      if (s[1]) begin
        next_state = BETWEEN_S2_S1;
      end else if (s[2]) begin
        next_state = BETWEEN_S3_S2;
      end else if (s[3]) begin
        next_state = ABOVE_S3;
      end
    end
    ABOVE_S3: begin
      if (!s[3]) begin
        next_state = BETWEEN_S3_S2;
      end
    end
    BETWEEN_S3_S2: begin
      if (s[3]) begin
        next_state = ABOVE_S3;
      end else if (!s[2]) begin
        next_state = BETWEEN_S2_S1;
      end
    end
    BETWEEN_S2_S1: begin
      if (s[2] && !s[1]) begin
        next_state = BETWEEN_S3_S2;
      end
    end
  endcase
end

always @* begin
  fr3 = 0;
  fr2 = 0;
  fr1 = 0;
  dfr = 0;

  case(state)
    IDLE: begin
      fr3 = 0;
      fr2 = 0;
      fr1 = 0;
    end
    ABOVE_S3: begin
      fr3 = 0;
      fr2 = 0;
      fr1 = 0;
    end
    BETWEEN_S3_S2: begin
      fr3 = 0;
      fr2 = 1;
      fr1 = 1;
    end
    BETWEEN_S2_S1: begin
      fr3 = 0;
      fr2 = 0;
      fr1 = 1;
      if (s[2] == 1 && s[3] == 0) begin
        dfr = 1;
      end
    end
  endcase
end

endmodule