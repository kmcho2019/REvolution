module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

typedef enum logic [1:0] {S0, S1, S2, S3} state_t;
reg state, next_state;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= S0;
    disc <= 0;
    flag <= 0;
    err <= 0;
  end
  else begin
    state <= next_state;
    case (state)
      S0: begin
        disc <= 0;
        flag <= 0;
        err <= 0;
        if (in) next_state = S1;
        else next_state = S0;
      end
      S1: begin
        disc <= in;
        flag <= (in && !disc);
        err <= 0;
        if (!in) next_state = S0;
        else next_state = S2;
      end
      S2: begin
        disc <= 0;
        flag <= 0;
        err <= 1;
        if (!in) next_state = S0;
        else next_state = S3;
      end
      S3: begin
        disc <= 0;
        flag <= (in && state == S2);
        err <= in;
        if (in) next_state = S1;
        else if (state == S2) next_state = S0;
        else next_state = S3;
      end
    endcase
  end
end

endmodule