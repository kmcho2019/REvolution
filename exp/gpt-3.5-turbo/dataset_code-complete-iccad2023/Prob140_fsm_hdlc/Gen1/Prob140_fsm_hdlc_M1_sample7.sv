module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

typedef enum logic [1:0] {S0, S1} state_t;
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
        if (!in & !next_state & state) next_state = S1; // look for '011'
        else next_state = S0;
      end
      S1: begin
        disc <= in;
        flag <= (in & !disc);
        err <= (in & disc);
        if (in) next_state = S1; // stay in S1 for processing
        else next_state = S0; // return to S0
      end
    endcase
  end
end

endmodule