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
parameter IDLE  = 2'b00;
parameter LOW   = 2'b01;
parameter MID   = 2'b10;
parameter HIGH  = 2'b11;

reg [1:0] state, next_state;

always @(posedge clk) begin
  if (reset) begin
    // Reset to initial state
    state <= IDLE;
  end else begin
    state <= next_state;
  end
end

always @(*) begin
  // Default values
  dfr = 0;
  fr3 = 0;
  fr2 = 0;
  fr1 = 0;
  
  case(state)
    IDLE: begin
      if(!s[1] && !s[2] && !s[3]) begin
        fr3 = 1; fr2 = 1; fr1 = 1;
        next_state = IDLE;
      end
      else if(s[1]) next_state = LOW;
      else if(s[2]) next_state = MID;
      else if(s[3]) next_state = HIGH;
    end
    LOW: begin
      if(s[1] && !s[2]) fr1 = 1;
      if(s[1] && s[2]) begin
        fr1 = 1; fr2 = 1;
        dfr = 1;
        next_state = LOW;
      end
      else next_state = MID;
    end
    MID: begin
      if(!s[1] && s[2]) begin
        fr1 = 1; fr2 = 1;
        next_state = MID;
      end
      else next_state = HIGH;
    end
    HIGH: begin
      if(s[3]) next_state = HIGH;
      else next_state = MID;
    end
  endcase 
end

endmodule