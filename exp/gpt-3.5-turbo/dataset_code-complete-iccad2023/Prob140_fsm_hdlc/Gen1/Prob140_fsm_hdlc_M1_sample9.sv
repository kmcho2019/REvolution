module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

typedef enum logic [1:0] {S0, S1, S2} state_t;
reg state, next_state;
reg disc_flag;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= S0;
    next_state <= S0;
    disc_flag <= 0;
    disc <= 0;
    flag <= 0;
    err <= 0;
  end
  else begin
    state <= next_state;
    disc_flag <= (state == S1 && in);

    case (state)
      S0: begin
        if (in) next_state = S1;
        else next_state = S0;
        disc <= 0;
        flag <= 0;
        err <= 0;
      end
      S1: begin
        if (in) next_state = S2;
        else next_state = S0;
        disc <= disc_flag;
        flag <= (in && !disc_flag);
        err <= 0;
      end
      S2: begin
        if (in) next_state = S2;
        else next_state = S0;
        disc <= 0;
        flag <= 0;
        err <= 1;
      end
    endcase
  end
end

endmodule