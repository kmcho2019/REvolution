module TopModule (
  input x,
  input y,
  output reg z
);

reg [1:0] state;

always @(*) begin
  case(state)
    2'b00: begin // State 00
      if (x == 1 && y == 0) begin
        state <= 2'b01;
        z <= 0;
      end else begin
        state <= 2'b00;
        z <= 1;
      end
    end
    2'b01: begin // State 01
      if (x == 0 && y == 1) begin
        state <= 2'b10;
        z <= 0;
      end else begin
        state <= 2'b01;
        z <= 0;
      end
    end
    2'b10: begin // State 10
      if (x == 1 && y == 1) begin
        state <= 2'b11;
        z <= 1;
      end else begin
        state <= 2'b10;
        z <= 0;
      end
    end
    2'b11: begin // State 11
      if (x == 0 && y == 0) begin
        state <= 2'b00;
        z <= 1;
      end else begin
        state <= 2'b11;
        z <= 1;
      end
    end
    default: state <= 2'b00;
  endcase
end
endmodule