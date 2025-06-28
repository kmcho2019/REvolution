module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg [1:0] current_state, next_state;

parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;

always @(posedge clk) begin
  current_state <= next_state;
end

always @(*) begin
  case(current_state)
    S0: begin
      next_state = a ? S1 : S0;
      q = 1'b0;
    end
    S1: begin
      next_state = b ? S2 : S1;
      q = 1'b1;
    end
    S2: begin
      next_state = a ? S3 : S2;
      q = 1'b1;
    end
    S3: begin
      next_state = ~(a | b) ? S0 : S3;
      q = 1'b0;
    end
  endcase
end

initial begin
  state = 1'b0;
  current_state = S0;
  next_state = S0;
  q = 1'b0;
end

endmodule