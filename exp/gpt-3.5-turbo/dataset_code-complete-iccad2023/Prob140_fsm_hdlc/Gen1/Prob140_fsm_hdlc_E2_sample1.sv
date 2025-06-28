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
  reg [4:0] shift_reg;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= S0;
      disc <= 0;
      flag <= 0;
      err <= 0;
      shift_reg <= 5'b0;
    end
    else begin
      state <= next_state;
      case (state)
        S0: begin
          disc <= 0;
          flag <= 0;
          err <= 0;
          if (in) begin
            shift_reg <= {shift_reg[3:0], in};
            if (shift_reg == 5'b0111110) begin
              disc <= 1;
              shift_reg <= 5'b0;
            end
            else if (in) begin
              next_state = S1;
            end
          end
        end
        S1: begin
          disc <= in;
          flag <= (in && !disc);
          err <= 0;
          if (!in) begin
            next_state = S0;
            disc <= 0;
          end
          else if (in)
            next_state = S2;
        end
        S2: begin
          disc <= 0;
          flag <= 0;
          err <= 1;
          if (!in) begin
            next_state = S0;
            err <= 0;
          end
          else if (in)
            next_state = S2;
        end
      endcase
    end
  end

endmodule