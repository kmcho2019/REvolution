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
    state <= LOW; // Reset to a state equivalent to low water level
  end else begin
    state <= next_state;
  end
end

always @* begin
  next_state = state;

  case(state)
    HIGH: begin
      if (!s[3]) begin
        next_state = MEDIUM;
      end
    end
    MEDIUM: begin
      if (!s[2]) begin
        next_state = LOW;
      end else if (s[3]) begin
        next_state = HIGH;
      end
    end
    LOW: begin
      if (s[1]) begin
        next_state = MEDIUM;
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
    HIGH: begin
      // No flow above s[3]
    end
    MEDIUM: begin
      fr1 = 1'b1;
      if (!s[2]) begin
        fr2 = 1'b1;
      end
      if (dfr) begin
        dfr = 1'b0; // Reset supplemental flow valve
      end
    end
    LOW: begin
      fr1 = 1'b1;
      fr2 = 1'b1;
      fr3 = 1'b1;
      if (!s[1]) begin
        dfr = 1'b1; // Activate supplemental flow valve if previous level was lower
      end
    end
  endcase
end

endmodule