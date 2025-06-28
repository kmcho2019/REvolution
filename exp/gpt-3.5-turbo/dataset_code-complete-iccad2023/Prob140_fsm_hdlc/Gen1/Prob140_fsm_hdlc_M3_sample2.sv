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
reg [2:0] consecutive_ones;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= S0;
    disc <= 0;
    flag <= 0;
    err <= 0;
    consecutive_ones <= 0;
  end
  else begin
    state <= next_state;
    case (state)
      S0: begin
        disc <= 0;
        flag <= 0;
        err <= 0;
        consecutive_ones <= (in) ? consecutive_ones + 1 : 0;
        if (consecutive_ones == 4 && in == 0) begin
          next_state = S1;
          disc <= 1;
        end else if (in) begin
          next_state = S2;
        end
      end
      S1: begin
        disc <= in;
        flag <= (in == 0 && consecutive_ones <= 4);
        consecutive_ones <= (in) ? consecutive_ones + 1 : 0;
        if (consecutive_ones == 2 && in == 0) begin
          next_state = S0;
        end
      end
      S2: begin
        disc <= 0;
        flag <= 0;
        err <= (in && consecutive_ones >= 6);
        consecutive_ones <= (in) ? consecutive_ones + 1 : 0;
        if (in == 0) begin
          next_state = S0;
        end
      end
    endcase
  end
end

endmodule