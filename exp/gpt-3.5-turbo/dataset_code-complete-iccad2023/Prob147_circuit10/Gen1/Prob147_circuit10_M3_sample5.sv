module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg [1:0] state_reg;

always @(posedge clk) begin
  case (state_reg)
    2'b00: begin
      state_reg <= (a & !b) ? 2'b01 : 2'b00;
    end
    2'b01: begin
      state_reg <= (a & b) ? 2'b11 : 2'b00;
    end
    2'b11: begin
      state_reg <= (!a & b) ? 2'b10 : 2'b00;
    end
    2'b10: begin
      state_reg <= (a & b) ? 2'b11 : 2'b00;
    end
    default: begin
      state_reg <= 2'b00;
    end
  endcase
end

always @* begin
  state = state_reg[1];
  q = (state_reg == 2'b01 || state_reg == 2'b10); 
end

endmodule