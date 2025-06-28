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
parameter IDLE = 3'b000;
parameter ABOVE_S3 = 3'b001;
parameter BTW_S3_S2 = 3'b010;
parameter BTW_S2_S1 = 3'b011;

reg [2:0] state, next_state;

always @(posedge clk) begin
  if (reset) begin
    state <= IDLE;
  end else begin
    state <= next_state;
  end
end

always @(*) begin
  fr3 = (state == ABOVE_S3 || state == IDLE) ? 1'b1 : 1'b0;
  fr2 = (state == BTW_S3_S2 || state == BTW_S2_S1 || state == IDLE) ? 1'b1 : 1'b0;
  fr1 = (state == BTW_S2_S1 || state == IDLE) ? 1'b1 : 1'b0;
  dfr = (state == BTW_S3_S2) ? 1'b1 : 1'b0;
end

always @(*) begin
  case(state)
    IDLE: begin
      if(!s[1] && !s[2] && !s[3])
        next_state = IDLE;
      else if(s[1] && s[2] && s[3])
        next_state = ABOVE_S3;
      else if(s[1] && s[2] && !s[3])
        next_state = BTW_S3_S2;
      else if(s[1] && !s[2] && !s[3])
        next_state = BTW_S2_S1;
    end
    ABOVE_S3: begin
      if (!(s[1] && s[2] && s[3]))
        next_state = BTW_S3_S2;
    end
    BTW_S3_S2: begin
      if (!(s[1] && s[2]))
        next_state = BTW_S2_S1;
      else if (!(s[1] && s[2] && s[3]))
        next_state = IDLE;
    end
    default: next_state = IDLE; // Reset state if none of the conditions are met
  endcase
end

endmodule