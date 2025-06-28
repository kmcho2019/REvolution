module TopModule (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

  reg [2:0] state;
  reg [2:0] next_state;
  reg disc_reg, flag_reg, err_reg;
  reg error_detected;
  
  always @ (posedge clk or posedge reset)
  begin
    if (reset) begin
      state <= 3'b100;  // IDLE state
      disc_reg <= 1'b0;
      flag_reg <= 1'b0;
      err_reg <= 1'b0;
      error_detected <= 1'b0;
    end
    else begin
      state <= next_state;
      disc_reg <= 1'b0;
      flag_reg <= 1'b0;
      err_reg <= 1'b0;
    end
  end
  
  always @ *
  begin
    case (state)
      3'b100: // IDLE
        if (in) next_state = 3'b101; // Move to GOT_1 if input is 1
        else next_state = 3'b100;    // Stay in IDLE
      3'b101: // GOT_1
        if (in) begin
          next_state = 3'b110; // Move to GOT_01 if input is still 1
        end
        else begin
          next_state = 3'b100;    // Move back to IDLE if input is 0
        end
      3'b110: // GOT_01
        begin
          if (in) begin
            next_state = 3'b111; // Move to GOT_011 if input is 1
            disc_reg = 1'b1;     // Signal a bit needs to be discarded
          end
          else begin
            next_state = 3'b100; // Move back to IDLE if input is 0
          end
        end
      3'b111: // GOT_011
        begin
          if (in) begin
            next_state = 3'b111; // Stay in GOT_011 if input is 1
            if (error_detected) begin
              err_reg = 1'b1; // Signal an error if 7 or more 1s detected
              next_state = 3'b100; // Move to IDLE after error
            end
          end
          else begin
            next_state = 3'b100; // Move back to IDLE if input is 0
            flag_reg = 1'b1;     // Signal a flag if 01111110 detected
            error_detected <= 1'b0; // Reset error flag
          end
          
          if (!error_detected) begin
            if (in) error_detected <= 1'b1; // Set error flag if consecutive 1s continue
          end
        end
    endcase
  end
  
  assign disc = disc_reg;
  assign flag = flag_reg;
  assign err = err_reg;

endmodule