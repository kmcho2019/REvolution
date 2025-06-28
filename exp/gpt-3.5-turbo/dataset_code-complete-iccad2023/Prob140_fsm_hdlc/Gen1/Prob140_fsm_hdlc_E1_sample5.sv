module TopModule (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);
  
  // Registers for state and outputs
  reg [1:0] state;
  reg disc, flag, err;

  // Single-bit shift register for disc pattern
  reg shift_reg;
  
  // Counter for consecutive 1s
  reg [2:0] one_count;

  always @(posedge clk or posedge reset) begin
    if (reset) begin // Initial state handling post-reset
      state <= 0;
      disc <= 0;
      flag <= 0;
      err <= 0;
      shift_reg <= 0;
      one_count <= 0;
    end
    else begin
      // State machine logic
      case (state)
        0: begin // Initial state
          if (in) begin
            state <= 1;
          end
        end
        1: begin // Looking for start of flag sequence
          if (shift_reg & in) begin
            disc <= 1; // Discard flag
          end
          shift_reg <= in;
          if (shift_reg & !in) begin
            state <= 2;
          end
        end
        2: begin // Looking for end of flag sequence
          if (in) begin
            flag <= 1; // Flag detected
            state <= 0;
          end
        end
        3: begin // Error state
          if (in) begin
            err <= 1; // Error detected
            state <= 0;
          end
        end
      endcase

      // Consecutive 1s count logic
      if (in) begin
        if (one_count == 6) begin
          state <= 3; // More than 6 consecutive 1s detected
        end
        else begin
          one_count <= one_count + 1;
        end
      end
      else begin
        one_count <= 0;
      end
    end
  end
endmodule