module TopModule (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

  // Registers for state, shift register, and previous input
  reg [2:0] state;
  reg [6:0] shift_reg;
  reg prev_in;

  // Assign initial states
  initial begin
    state <= 3'b000;
    disc <= 0;
    flag <= 0;
    err <= 0;
  end

  always @(posedge clk) begin
    if (reset) begin
      state <= 3'b000;
      prev_in <= 1'b0;
      shift_reg <= 7'b0;
      disc <= 0;
      flag <= 0;
      err <= 0;
    end
    else begin
      prev_in <= in;
      shift_reg <= {shift_reg[5:0], in};
      case (state)
        3'b000: begin // Waiting for a start of flag sequence
          if (shift_reg == 7'b0111110) begin
            disc <= 1;
            state <= 3'b001;
          end
          else if (in) begin
            state <= 3'b010;
          end
        end
        3'b001: begin // Output discarding, then back to waiting for start
          disc <= 0;
          state <= 3'b000;
        end
        3'b010: begin // Detected start of flag sequence
          if (shift_reg == 7'b01111110) begin
            flag <= 1;
            state <= 3'b011;
          end
          else if (!in) begin
            state <= 3'b000;
          end
        end
        3'b011: begin // Output flag, wait for possible error
          flag <= 0;
          state <= 3'b100;
        end
        3'b100: begin // Detected 7 or more 1s, indicating error
          if (in) begin
            err <= 1;
          end
          else begin
            err <= 0;
            state <= 3'b000;
          end
        end
      endcase
    end
  end

endmodule