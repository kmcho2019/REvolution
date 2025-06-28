module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

// State parameters
parameter S_ABOVE_S3 = 2'b00;
parameter S_BETWEEN_S3_S2 = 2'b01;
parameter S_BETWEEN_S2_S1 = 2'b10;
parameter S_BELOW_S1 = 2'b11;

reg [1:0] state, next_state;

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    state <= S_BELOW_S1;
  end else begin
    state <= next_state;
  end
end

always @* begin
  case (state)
    S_ABOVE_S3: begin
      if (s[2]) next_state = S_BETWEEN_S3_S2;
      else if (s[1]) next_state = S_BETWEEN_S2_S1;
      else next_state = S_BELOW_S1;
    end
    S_BETWEEN_S3_S2: begin
      if (s[3]) next_state = S_ABOVE_S3;
      else if (s[1]) next_state = S_BETWEEN_S2_S1;
      else next_state = S_BELOW_S1;
    end
    S_BETWEEN_S2_S1: begin
      if (s[3]) next_state = S_ABOVE_S3;
      else if (s[2]) next_state = S_BETWEEN_S3_S2;
      else next_state = S_BELOW_S1;
    end
    S_BELOW_S1: begin
      if (s[3]) next_state = S_ABOVE_S3;
      else if (s[2]) next_state = S_BETWEEN_S3_S2;
      else next_state = S_BELOW_S1;
    end
    default: next_state = S_BELOW_S1;
  endcase
end

always @* begin
  case (state)
    S_ABOVE_S3: begin
      fr3 = 0;
      fr2 = 0;
      fr1 = 0;
      dfr = 0;
    end
    S_BETWEEN_S3_S2: begin
      fr3 = 0;
      fr2 = 1;
      fr1 = 0;
      dfr = 0;
    end
    S_BETWEEN_S2_S1: begin
      fr3 = 0;
      fr2 = 1;
      fr1 = 1;
      dfr = 1;
    end
    S_BELOW_S1: begin
      fr3 = 1;
      fr2 = 1;
      fr1 = 1;
      dfr = 1;
    end
    default: begin
      fr3 = 1;
      fr2 = 1;
      fr1 = 1;
      dfr = 1;
    end
  endcase
end

endmodule