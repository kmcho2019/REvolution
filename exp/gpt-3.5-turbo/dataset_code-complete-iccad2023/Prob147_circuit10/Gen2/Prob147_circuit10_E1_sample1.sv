module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

always @ (posedge clk) begin
  case({state, a, b})
    3'b000: begin
      q <= 1;
      state <= 3'b001;
    end
    3'b001: begin
      q <= a;
      state <= 3'b010;
    end
    3'b010: begin
      q <= a;
      state <= 3'b100;
    end
    3'b100: begin
      q <= ~(a & b);
      state <= 3'b000;
    end
  endcase
end

endmodule