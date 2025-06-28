module TopModule (
  input clk,
  input j,
  input k,
  input reset,
  output reg out
);

// Define the two states
typedef enum { OFF, ON } state_type;
reg [1:0] state, next_state;

// State register with synchronous reset
always @(posedge clk or posedge reset)
begin
  if (reset)
    state <= OFF;
  else
    state <= next_state;
end

// State transition logic
always @(*)
begin
  case (state)
    OFF:
      begin
        if (j)
          next_state = ON;
        else
          next_state = OFF;
      end
    ON:
      begin
        if (k)
          next_state = OFF;
        else
          next_state = ON;
      end
  endcase
end

// Output logic
always @(*)
begin
  case (state)
    OFF: out = 1'b0;
    ON: out = 1'b1;
  endcase
end

endmodule