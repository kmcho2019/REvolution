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
      if (s[3]) begin
        next_state = HIGH;
        fr3 <= 1'b0;
        fr2 <= 1'b0;
        fr1 <= 1'b0;
        dfr <= 1'b0;
      end else if (s[2]) begin
        next_state = MEDIUM;
        fr2 <= 1'b0;
        fr1 <= 1'b0;
        fr3 <= 1'b1;
        dfr <= 1'b0;
      end else if (s[1]) begin
        next_state = LOW;
        fr1 <= 1'b0;
        fr2 <= 1'b0;
        fr3 <= 1'b0;
        dfr <= 1'b1;
      end
    end
    HIGH: begin
      if (!s[3]) begin
        next_state = MEDIUM;
        fr3 <= 1'b0;
        fr2 <= 1'b0;
        fr1 <= 1'b0;
        dfr <= 1'b0;
      end
    end
    MEDIUM: begin
      if (s[3]) begin
        next_state = HIGH;
        fr3 <= 1'b0;
        fr2 <= 1'b0;
        fr1 <= 1'b0;
        dfr <= 1'b0;
      end else if (!s[2]) begin
        next_state = LOW;
        fr2 <= 1'b0;
        fr1 <= 1'b1;
        fr3 <= 1'b1;
        dfr <= 1'b0;
      end
    end
    LOW: begin
      if (s[1]) begin
        next_state = MEDIUM;
        fr1 <= 1'b0;
        fr2 <= 1'b1;
        fr3 <= 1'b1;
        if (state == MEDIUM && s[1] && !s[2]) begin
          dfr <= 1'b1;
        end
      end
    end
  endcase
end

endmodule