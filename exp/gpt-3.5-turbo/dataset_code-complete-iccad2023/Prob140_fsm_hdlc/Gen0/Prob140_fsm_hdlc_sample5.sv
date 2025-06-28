module HDLC_FSM (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);
  
  // Define states
  parameter IDLE = 2'b00;
  parameter ONE = 2'b01;
  parameter TWO = 2'b10;
  parameter ERR = 2'b11;
  
  // Define state register
  reg [1:0] state, next_state;
  
  // Define output registers
  reg disc_reg, flag_reg, err_reg;
  
  // State transition and output logic
  always @ (posedge clk, posedge reset)
  begin
    if (reset) begin
      state <= IDLE;
      disc_reg <= 1'b0;
      flag_reg <= 1'b0;
      err_reg <= 1'b0;
    end
    else begin
      state <= next_state;
      disc_reg <= 1'b0;
      flag_reg <= 1'b0;
      err_reg <= 1'b0;

      case (state)
        IDLE:
          begin
            if (in == 1'b0)
              next_state = ONE;
            else
              next_state = IDLE;
          end
        ONE:
          begin
            if (in == 1'b0)
              next_state = ONE;
            else if (in == 1'b1)
              next_state = TWO;
          end
        TWO:
          begin
            if (in == 1'b0) begin
              next_state = ONE;
              disc_reg = 1'b1;
            end
            else if (in == 1'b1)
              next_state = ERR;
            else if (in == 1'b0)
              next_state = IDLE;
          end
        ERR:
          begin
            if (in == 1'b1)
              next_state = ERR;
            else
              next_state = IDLE;
          end
      endcase
    end
  end

  // Assign outputs
  assign disc = disc_reg;
  assign flag = flag_reg;
  assign err = err_reg;

endmodule