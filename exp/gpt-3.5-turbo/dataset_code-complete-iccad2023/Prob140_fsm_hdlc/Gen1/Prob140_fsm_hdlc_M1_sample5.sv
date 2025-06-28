module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

typedef enum logic [1:0] {S_IDLE, S_0111, S_01111, S_ERR} state_t;
reg state, next_state;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= S_IDLE;
    disc <= 0;
    flag <= 0;
    err <= 0;
  end
  else begin
    state <= next_state;
    case (state)
      S_IDLE: begin
        disc <= 0;
        flag <= 0;
        err <= 0;
        if (in) next_state = S_0111;
        else next_state = S_IDLE;
      end
      S_0111: begin
        disc <= in;
        flag <= 0;
        err <= 0;
        if (in) next_state = S_01111;
        else next_state = S_IDLE;
      end
      S_01111: begin
        disc <= 0;
        flag <= in;
        err <= 0;
        if (in) next_state = S_ERR;
        else next_state = S_0111;
      end
      S_ERR: begin
        disc <= 0;
        flag <= 0;
        err <= 1;
        if (in) next_state = S_0111;
        else next_state = S_IDLE;
      end
    endcase
  end
end

endmodule