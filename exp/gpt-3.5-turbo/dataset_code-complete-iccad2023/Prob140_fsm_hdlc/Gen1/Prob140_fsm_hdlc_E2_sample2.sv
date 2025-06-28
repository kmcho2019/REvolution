module TopModule (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);
  
  // Registers for state and previous input
  reg [1:0] state;
  reg prev_in;
  
  // 5-bit shift register for "0111110" detection
  reg [4:0] shift_reg_disc;
  
  // 7-bit shift register for error detection
  reg [6:0] shift_reg_error;
  
  // Assign initial states
  initial begin
    state <= 0;
    disc <= 0;
    flag <= 0;
    err <= 0;
  end
  
  always @(posedge clk) begin
    if (reset) begin
      state <= 0;
      prev_in <= 0;
      shift_reg_disc <= 5'b0;
      shift_reg_error <= 7'b0;
      disc <= 0;
    end
    else begin
      prev_in <= in;
      case (state)
        0: begin // Looking for start of flag sequence
          if (prev_in & !in) begin
            shift_reg_disc <= {shift_reg_disc[3:0], in};
            if (shift_reg_disc == 5'b0111110) begin
              disc <= 1;
              shift_reg_disc <= 5'b0;
            end
            else if (in) begin
              state <= 1;
            end
          end
        end
        1: begin // Looking for end of flag sequence
          if (prev_in & !in) begin
            if (in) begin
              state <= 2;
              flag <= 1;
            end
            else begin
              state <= 0;
              disc <= 0;
            end
          end
        end
        2: begin // Error state
          if (prev_in & !in) begin
            shift_reg_error <= {shift_reg_error[5:0], in};
            if (shift_reg_error[6] & in) begin
              err <= 1;
            end
            else begin
              err <= 0;
              state <= 0;
            end
          end
        end
      endcase
    end
  end

endmodule