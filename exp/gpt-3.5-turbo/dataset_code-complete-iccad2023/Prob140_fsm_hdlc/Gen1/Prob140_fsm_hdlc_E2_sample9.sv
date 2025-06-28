module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

reg [5:0] shift_reg;
reg [1:0] state;
reg prev_in;

parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= S0;
    shift_reg <= 6'b0;
    prev_in <= 1'b0;
    disc <= 0;
    flag <= 0;
    err <= 0;
  end
  else begin
    prev_in <= in;
    case (state)
      S0: begin
        if (in == 1'b1 && shift_reg == 6'b011111) begin
          disc <= 1;
          shift_reg <= 6'b0;
          state <= S1;
        end
        else begin
          shift_reg <= {shift_reg[4:0], in};
          disc <= 0;
        end
      end
      S1: begin
        if (in == 1'b0 && prev_in == 1'b1) begin
          flag <= 1;
          state <= S2;
        end
        else if (in == 1'b1) begin
          disc <= 1;
        end
        else begin
          disc <= 0;
        end
      end
      S2: begin
        if (in == 1'b1) begin
          state <= S3;
          err <= 1;
        end
        else if (in == 1'b0 && prev_in == 1'b1) begin
          flag <= 1;
          state <= S0;
        end
        else begin
          flag <= 0;
        end
      end
      S3: begin
        if (in == 1'b0 && prev_in == 1'b1) begin
          flag <= 1;
          state <= S0;
        end
        else begin
          err <= 0;
        end
      end
    endcase
  end
end

endmodule