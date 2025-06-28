module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

  // Registers for state and previous input
  reg [1:0] state;
  reg prev_in;

  // 5-bit shift register for disc pattern
  reg [4:0] shift_reg;

  // Moore FSM states
  localparam S0 = 2'b00;
  localparam S1 = 2'b01;
  localparam S2 = 2'b10;

  // Assign initial states
  initial begin
    state <= S0;
    disc <= 0;
    flag <= 0;
    err <= 0;
  end

  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
      prev_in <= 0;
      shift_reg <= 5'b0;
      disc <= 0;
    end
    else begin
      prev_in <= in;
      case (state)
        S0: begin // Looking for start of flag sequence
          if (prev_in & !in) begin
            shift_reg <= {shift_reg[3:0], in};
            if (shift_reg == 5'b0111110) begin
              disc <= 1;
              shift_reg <= 5'b0;
            end
            else if (in) begin
              state <= S1;
            end
          end
        end
        S1: begin // Looking for end of flag sequence
          if (prev_in & !in) begin
            if (in) begin
              state <= S2;
              flag <= 1;
            end
            else begin
              state <= S0;
              disc <= 0;
            end
          end
        end
        S2: begin // Error state
          if (prev_in & !in) begin
            if (in) begin
              err <= 1;
            end
            else begin
              err <= 0;
              state <= S0;
            end
          end
        end
      endcase
    end
  end

endmodule