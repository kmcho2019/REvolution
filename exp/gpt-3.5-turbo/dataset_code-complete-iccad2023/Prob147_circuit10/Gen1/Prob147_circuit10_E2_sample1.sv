module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg [1:0] state_next;

always @(posedge clk) begin
  state <= state_next;
end

always @(*) begin
  case (state)
    2'b00: begin
      if (a == 1 && b == 1) begin
        state_next = 2'b01;
        q = 1'b0;
      end
      else begin
        state_next = 2'b00;
        q = 1'b0;
      end
    end
    2'b01: begin
      if (a == 0 && b == 1) begin
        state_next = 2'b10;
        q = 1'b1;
      end
      else if (a == 1 && b == 0) begin
        state_next = 2'b00;
        q = 1'b0;
      end
      else begin
        state_next = 2'b01;
        q = 1'b0;
      end
    end
    2'b10: begin
      if (a == 1 && b == 1) begin
        state_next = 2'b11;
        q = 1'b1;
      end
      else begin
        state_next = 2'b00;
        q = 1'b0;
      end
    end
    2'b11: begin
      if (a == 0 && b == 1) begin
        state_next = 2'b10;
        q = 1'b1;
      end
      else begin
        state_next = 2'b00;
        q = 1'b0;
      end
    end
    default: begin
      state_next = 2'b00;
      q = 1'b0;
    end
  endcase
end

endmodule