module TopModule (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

  reg [2:0] state;
  reg [4:0] shift_reg;
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 3'b000;
      shift_reg <= 5'b0;
      disc <= 0;
      flag <= 0;
      err <= 0;
    end
    else begin
      case (state)
        3'b000: begin // State 0: Waiting for the start of a sequence
          if (in) begin
            shift_reg <= {shift_reg[3:0], in};
            if (shift_reg == 5'b0111110) begin
              disc <= 1;
              shift_reg <= 5'b0;
              state <= 3'b001;
            end
            else state <= 3'b001;
          end
        end
        3'b001: begin // State 1: Detected 1
          if (in) state <= 3'b010; // Transition to state 2 (01 detected)
          else state <= 3'b000; // Reset back to state 0
        end
        3'b010: begin // State 2: Detected 01
          if (in) begin
            disc <= 1; // Signal discarded bit
            shift_reg <= 5'b0; // Reset shift register for new pattern
            state <= 3'b001; // Go back to state 1
          end
          else state <= 3'b011; // Transition to state 3 (011 detected)
        end
        3'b011: begin // State 3: Detected 011
          if (in) begin
            err <= 1; // More than 7 ones, signal error
            state <= 3'b000; // Reset back to state 0
          end
          else begin
            flag <= 1; // Flag the frame
            state <= 3'b100; // Transition to 'WAIT' state
          end
        end
        3'b100: begin // 'WAIT' state after frame flag detection
          flag <= 1; // Keep flag high for a complete cycle
          if (!in) state <= 3'b000; // Start back at state 0 upon flag end
        end
      endcase
    end
  end

endmodule