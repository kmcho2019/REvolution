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
  
  always @ (posedge clk or posedge reset)
  begin
    if (reset) begin
      state <= 3'b100;  // IDLE state
      disc_reg <= 1'b0;
      flag_reg <= 1'b0;
      err_reg <= 1'b0;
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
        begin
          if (in) next_state = 3'b101; // GOT_1
          else next_state = 3'b100;    // IDLE
        end
      3'b101: // GOT_1
        begin
          if (in) next_state = 3'b110; // GOT_01
          else next_state = 3'b100;    // IDLE
        end
      3'b110: // GOT_01
        begin
          if (in) begin
            next_state = 3'b111; // GOT_011
            disc_reg = 1'b1;     // 0111110: Signal a bit needs to be discarded
          end
          else next_state = 3'b100; // IDLE
        end
      3'b111: // GOT_011
        begin
          if (in) begin
            next_state = 3'b111; // GOT_011
            err_reg = 1'b1;      // 7 or more 1s
          end
          else begin
            next_state = 3'b100; // IDLE
            flag_reg = 1'b1;     // 01111110: Flag the beginning/end of a frame
          end
        end
    endcase
  end
  
  assign disc = disc_reg;
  assign flag = flag_reg;
  assign err = err_reg;

endmodule