module HDLC_Frame (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

  // State declaration
  reg [1:0] state, next_state;

  // Output signals
  reg disc_reg, flag_reg, err_reg;

  // Next state logic and output assignments
  always @(*) begin
    disc = 0;
    flag = 0;
    err = 0;

    case (state)
      2'b00: begin // State S0
        if(in) begin
          next_state = 2'b01;
          disc_reg = 0;
          flag_reg = 0;
        end else begin
          next_state = 2'b00;
          disc_reg = 0;
          flag_reg = 0;
        end
      end

      2'b01: begin // State S1
        if(in) begin
          next_state = 2'b10;
          disc_reg = 0;
          flag_reg = 0;
        end else begin
          next_state = 2'b00;
          disc_reg = 1;
          flag_reg = 0;
        end
      end

      2'b10: begin // State S2
        if(in) begin
          next_state = 2'b10;
          disc_reg = 0;
          flag_reg = 0;
          err_reg = 1;
        end else begin
          next_state = 2'b00;
          disc_reg = 0;
          flag_reg = 1;
          err_reg = 0;
        end
      end

    endcase
  end

  // State transition
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      state <= 2'b00;
    end else begin
      state <= next_state;
    end
  end

  // Output register assignments
  always @(posedge clk) begin
    disc <= disc_reg;
    flag <= flag_reg;
    err <= err_reg;
  end

endmodule