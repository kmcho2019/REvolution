module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg [1:0] current_state;

parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;

always @(posedge clk) begin
  case (current_state)
    S0: begin
      if (a == 1) current_state <= S1;
    end
    S1: begin
      if (b == 1) current_state <= S2;
    end
    S2: begin
      if (a == 0) current_state <= S3;
    end
    S3: begin
      if (b == 0) current_state <= S0;
    end
    default: current_state <= S0;
  endcase
end

always @* begin
  q = (current_state == S1) ? 1'b1 : 1'b0;
  state = (current_state == S3) ? 1'b1 : 1'b0;
end

endmodule