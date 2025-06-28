module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

// State definition
parameter IDLE = 2'b00, ABOVE = 2'b01, BETWEEN_32 = 2'b10, BETWEEN_21 = 2'b11;
reg [1:0] state, next_state;

// Nominal flow rate constants
parameter fr1 = 2'b01, fr2 = 2'b10, fr3 = 2'b11;

always @ (posedge clk or posedge reset)
begin
  if (reset)
  begin
    state <= IDLE;
    fr3 <= 1'b1;
    fr2 <= 1'b1;
    fr1 <= 1'b1;
    dfr <= 1'b1;
  end
  else
  begin
    state <= next_state;
    case(state)
      IDLE:
        begin
          if (s[1] && s[2] && s[3])
            next_state = ABOVE;
          else if (s[1] && s[2] && !s[3])
            next_state = BETWEEN_32;
          else if (s[1] && !s[2] && !s[3])
            next_state = BETWEEN_21;
          else if (!s[1] && !s[2] && !s[3])
            next_state = IDLE;
        end
      ABOVE:
        begin
          if (!s[3])
            next_state = BETWEEN_32;
          else
            next_state = ABOVE;
        end
      BETWEEN_32:
        begin
          if (s[1] && s[2])
            next_state = BETWEEN_32;
          else if (!s[2])
            next_state = BETWEEN_21;
          else
            next_state = ABOVE;
        end
      BETWEEN_21:
        begin
          if (s[1])
            next_state = BETWEEN_21;
          else
            next_state = IDLE;
        end
    endcase
  end
end

// Output logic
always @*
begin
  case(state)
    IDLE: begin fr3 = 1'b1; fr2 = 1'b1; fr1 = 1'b1; dfr = 1'b1; end
    ABOVE: begin fr3 = 1'b0; fr2 = 1'b1; fr1 = 1'b1; dfr = 1'b1; end
    BETWEEN_32: begin fr3 = 1'b0; fr2 = 1'b0; fr1 = 1'b1; dfr = s[2] && !s[3]; end
    BETWEEN_21: begin fr3 = 1'b0; fr2 = 1'b0; fr1 = 1'b0; dfr = 1'b1; end
  endcase
end

endmodule