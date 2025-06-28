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
parameter BELOW_S1 = 2'b100;

reg [2:0] state, next_state;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
  end else begin
    state <= next_state;
  end
end

always @* begin
  next_state = state;

  case(state)
    IDLE: begin
      if (s[1]) begin
        next_state = BELOW_S1;
      end else if (s[2]) begin
        next_state = BETWEEN_S2_S1;
      end else if (s[3]) begin
        next_state = ABOVE_S3;
      end else if (s[2]) begin
        next_state = BETWEEN_S3_S2;
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
      if (s[2]) begin
        next_state = BETWEEN_S3_S2;
      end else if (!s[1]) begin
        next_state = BELOW_S1;
      end
    end
    BELOW_S1: begin
      if (s[1]) begin
        next_state = BETWEEN_S2_S1;
      end
    end
  endcase
end

always @* begin
  fr3 = 1'b0;
  fr2 = 1'b0;
  fr1 = 1'b0;
  dfr = 1'b0;

  case(state)
    ABOVE_S3: begin
      // Do nothing, keep flow rates at 0
    end
    BETWEEN_S3_S2: begin
      fr1 = 1'b1;
    end
    BETWEEN_S2_S1: begin
      fr1 = 1'b1;
      fr2 = 1'b1;
    end
    BELOW_S1: begin
      fr1 = 1'b1;
      fr2 = 1'b1;
      fr3 = 1'b1;
      if (s[1] && !s[2]) begin
        dfr = 1'b1;
      end
    end
  endcase
end

endmodule