module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

reg [1:0] state;

always @(posedge clock) begin
  case (state)
    0: begin
      p <= 0;
      q <= 0;
      state <= (a == 1) ? 1 : 0;
    end
    1: begin
      p <= 1;
      state <= (a == 0) ? 0 : 2;
    end
    2: begin
      q <= 1;
      state <= 0;
    end
  endcase
end

endmodule