module TopModule (
  input x,
  input y,
  output z
);

reg [1:0] state, next_state;

parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;

always @(*) begin
  next_state = state;
  
  case(state)
    S0: begin
      if(x == 1 && y == 0) begin
        next_state = S1;
      end
    end
    S1: begin
      if(x == 0 && y == 1) begin
        next_state = S2;
      end
      else if(x == 1 && y == 1) begin
        next_state = S3;
      end
    end
    S2: begin
      if(x == 0 && y == 1) begin
        next_state = S3;
      end
      else if(x == 1 && y == 1) begin
        next_state = S3;
      end
    end
    S3: begin
      if(x == 0 && y == 0) begin
        next_state = S0;
      end
    end
  endcase
end

always @(posedge clk) begin
  state <= next_state;
end

assign z = (state == S3) ? 1 : 0;

endmodule