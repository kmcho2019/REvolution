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
parameter ABOVE_S3 = 3'b100;
parameter BTW_S3_S2 = 3'b010;
parameter BTW_S2_S1 = 3'b001;

// State and next state registers
reg [2:0] state, next_state;

always @(posedge clk) begin
  if (reset) begin
    state <= IDLE;
  end else begin
    state <= next_state;
  end
end

// Output control logic based on current state
always @(*) begin
  fr3 = (state == ABOVE_S3 || state == IDLE) ? 1'b0 : 1'b1;
  fr2 = (state != ABOVE_S3) ? 1'b0 : 1'b1;
  fr1 = (state != ABOVE_S3 && state != BTW_S2_S1) ? 1'b0 : 1'b1;
  dfr = (state == BTW_S3_S2) ? 1'b1 : 1'b0;
end

// State transition logic based on sensor inputs and current state
always @(*) begin
  case(state)
    IDLE: begin
      if (s[3]) next_state = ABOVE_S3;
    end
    ABOVE_S3: begin
      if (!s[3]) next_state = (s[2]) ? BTW_S3_S2 : IDLE;
    end
    BTW_S3_S2: begin
      if (!s[2]) next_state = (s[1]) ? BTW_S2_S1 : IDLE;
    end
    BTW_S2_S1: begin
      if (!s[1]) next_state = IDLE;
      else if (s[2]) next_state = BTW_S3_S2;
    end
    default: next_state = IDLE; // Reset state if none of the conditions met
  endcase
end

endmodule