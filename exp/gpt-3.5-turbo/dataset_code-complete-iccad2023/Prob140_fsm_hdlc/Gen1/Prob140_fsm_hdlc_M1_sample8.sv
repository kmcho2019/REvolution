module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

typedef enum logic [1:0] {IDLE, FLAG_DETECTED, ERROR} state_t;
reg state, next_state;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    disc <= 0;
    flag <= 0;
    err <= 0;
  end
  else begin
    state <= next_state;
    case (state)
      IDLE: begin
        disc <= 0;
        flag <= 0;
        err <= 0;
        if (in == 1) next_state = FLAG_DETECTED;
        else next_state = IDLE;
      end
      FLAG_DETECTED: begin
        disc <= in;
        flag <= (in == 0 && disc == 1);
        err <= 0;
        if (in == 0) next_state = IDLE;
        else if (in == 1) next_state = ERROR;
        else next_state = FLAG_DETECTED;
      end
      ERROR: begin
        disc <= 0;
        flag <= 0;
        err <= 1;
        if (in == 0) next_state = IDLE;
        else next_state = ERROR;
      end
    endcase
  end
end

endmodule