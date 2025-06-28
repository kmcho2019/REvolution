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
parameter IDLE = 2'b00, LOW = 2'b01, MID = 2'b10, HIGH = 2'b11;
reg [1:0] state, next_state;

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
        if (s[3]) next_state = HIGH;
        else if (s[2]) next_state = MID;
        else if (s[1]) next_state = LOW;
        else next_state = IDLE;
      end
      LOW: begin
        if (s[1] && !s[2]) fr1 <= 1'b1;
        else if (s[1] && s[2]) begin
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          dfr <= 1'b1;
          next_state = LOW;
        end
        else next_state = MID;
      end
      MID: begin
        if (!s[1] && s[2]) begin
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          next_state = MID;
        end
        else next_state = HIGH;
      end
      HIGH: begin
        if (s[3]) next_state = HIGH;
        else next_state = MID;
      end
    endcase
  end
end

endmodule