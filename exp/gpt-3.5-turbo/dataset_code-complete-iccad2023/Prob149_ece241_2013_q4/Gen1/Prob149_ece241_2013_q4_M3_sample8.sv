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
parameter HIGH = 2'b01;
parameter MEDIUM = 2'b10;
parameter LOW = 2'b11;

reg [1:0] state, next_state;

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
      if (s[1] && s[2] && s[3]) begin
        next_state = HIGH;
      end else if (s[1] && s[2]) begin
        next_state = MEDIUM;
      end else if (s[1]) begin
        next_state = LOW;
      end
    end
    HIGH: begin
      if (!(s[1] && s[2] && s[3])) begin
        next_state = MEDIUM;
      end
    end
    MEDIUM: begin
      if (s[1] && s[2]) begin
        next_state = HIGH;
      end else if (s[1] && !s[2]) begin
        next_state = LOW;
      end
    end
    LOW: begin
      if (s[1] && !s[2]) begin
        next_state = MEDIUM;
      end
    end
  endcase
end

always @* begin
  fr3 = (state == IDLE || state == HIGH) ? 1'b0 : 1'b1;
  fr2 = (state == IDLE || state == MEDIUM || state == HIGH) ? 1'b0 : 1'b1;
  fr1 = (state == IDLE || state == LOW || state == MEDIUM) ? 1'b0 : 1'b1;
  dfr = (state == LOW && (state != next_state || (state == next_state && s[1] && !s[2]))) ? 1'b1 : 1'b0;
end

endmodule