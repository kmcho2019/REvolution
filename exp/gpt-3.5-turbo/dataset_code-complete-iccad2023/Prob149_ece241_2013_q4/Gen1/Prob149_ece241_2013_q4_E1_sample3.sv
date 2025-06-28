module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

// Priority encoder for water level determination
assign s_priority = s[3] ? 3 :
                    s[2] ? 2 :
                    s[1] ? 1 :
                    0;

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
      if (s_priority == 3) begin
        next_state = HIGH;
      end else if (s_priority == 2) begin
        next_state = MEDIUM;
      end else if (s_priority == 1) begin
        next_state = LOW;
      end
    end
    HIGH: begin
      if (s[3] == 0) begin
        next_state = MEDIUM;
      end
    end
    MEDIUM: begin
      if (s_priority == 3) begin
        next_state = HIGH;
      end else if (s_priority == 1) begin
        next_state = LOW;
      end
    end
    LOW: begin
      if (s_priority == 1) begin
        next_state = MEDIUM;
      end
    end
  endcase
end

always @* begin
  fr3 = 0;
  fr2 = 0;
  fr1 = 0;
  dfr = 0;

  case(s_priority)
    3: begin
      // Water level above s[3]
      // Do nothing, keep flow rates at 0
    end
    2: begin
      // Water level between s[3] and s[2]
      fr1 = 1;
    end
    1: begin
      // Water level between s[2] and s[1]
      fr1 = 1;
      fr2 = 1;
    end
    0: begin
      // Water level below s[1]
      fr1 = 1;
      fr2 = 1;
      fr3 = 1;
      if (state == MEDIUM && s[1] && !s[2]) begin
        dfr = 1;
      end
    end
  endcase
end

endmodule