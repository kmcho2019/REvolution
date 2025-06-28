module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

reg state;

always @(posedge clock) begin
  case(state)
    0: begin
      if (a == 1) begin
        p <= 1;
        q <= 1;
        state <= 1;
      end
    end
    1: begin
      if (a == 0) begin
        q <= 0;
        state <= 0;
      end
    end
  endcase
end

endmodule