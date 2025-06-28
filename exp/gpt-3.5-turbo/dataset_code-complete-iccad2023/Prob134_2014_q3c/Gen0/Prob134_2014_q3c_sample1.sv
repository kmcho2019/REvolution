module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

reg [2:0] state_reg, next_state;
parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100;
reg [1:0] z_state;

always @ (posedge clk) begin
  case (state_reg)
    S0: begin
      z_state <= 2'b00;
      if (x == 0)
        next_state <= S0;
      else
        next_state <= S1;
    end
    S1: begin
      z_state <= 2'b00;
      if (x == 0)
        next_state <= S1;
      else
        next_state <= S4;
    end
    S2: begin
      z_state <= 2'b00;
      if (x == 0)
        next_state <= S2;
      else
        next_state <= S1;
    end
    S3: begin
      z_state <= 2'b01;
      if (x == 0)
        next_state <= S1;
      else
        next_state <= S2;
    end
    S4: begin
      z_state <= 2'b01;
      if (x == 0)
        next_state <= S3;
      else
        next_state <= S4;
    end
    default: next_state <= S0;
  endcase
end

always @ (*) begin
  case (state_reg)
    S0: begin
      Y0 = 1'b0;
      z = (z_state == 2'b01) ? 1 : 0;
    end
    S1: begin
      Y0 = 1'b0;
      z = (z_state == 2'b01) ? 1 : 0;
    end
    S2: begin
      Y0 = 1'b0;
      z = (z_state == 2'b01) ? 1 : 0; 
    end
    S3: begin
      Y0 = 1'b0;
      z = (z_state == 2'b01) ? 1 : 0; 
    end
    S4: begin
      Y0 = 1'b1;
      z = (z_state == 2'b01) ? 1 : 0; 
    end
    default: begin
      Y0 = 1'b0;
      z = 1'b0;
    end
  endcase
end

always @ (posedge clk) begin
  state_reg <= next_state;
end

endmodule