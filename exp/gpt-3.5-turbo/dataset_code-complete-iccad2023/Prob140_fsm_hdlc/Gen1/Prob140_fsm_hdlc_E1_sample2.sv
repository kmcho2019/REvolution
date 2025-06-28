module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

reg [6:0] shift_reg_disc;
reg [7:0] shift_reg_flag;
reg [1:0] state;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= 2'b00;
    shift_reg_disc <= 7'b0;
    shift_reg_flag <= 8'b0;
    disc <= 0;
    flag <= 0;
    err <= 0;
  end
  else begin
    case (state)
      2'b00: begin // State S0
        disc <= 0;
        flag <= 0;
        err <= 0;

        shift_reg_disc <= {shift_reg_disc[5:0], in};
        shift_reg_flag <= {shift_reg_flag[6:0], in};

        if (shift_reg_disc == 7'b0111110) begin
          disc <= 1;
          state <= 2'b01;
        end
        else if (shift_reg_flag == 8'b01111110) begin
          flag <= 1;
          state <= 2'b10;
        end
        else if (in == 1) begin
          state <= 2'b11;
        end
      end
      2'b01: begin // State S1
        disc <= 1;
        flag <= 0;
        err <= 0;

        if (in == 0) begin
          state <= 2'b00;
        end
      end
      2'b10: begin // State S2
        disc <= 0;
        flag <= 1;
        err <= 0;

        if (in == 0) begin
          state <= 2'b00;
        end
      end
      2'b11: begin // State S3 - Error state
        disc <= 0;
        flag <= 0;
        err <= 1;

        if (in == 0) begin
          state <= 2'b00;
        end
      end
    endcase
  end
end

endmodule