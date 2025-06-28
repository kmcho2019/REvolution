module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

  reg [1:0] state;

  always @(posedge clock) begin
    case(state)
      2'b00: begin // State 0
        if (a == 1) begin
          state <= 2'b01;
        end
        p <= 0; q <= 0;
      end
      
      2'b01: begin // State 1
        if (a == 0) begin
          state <= 2'b00;
        end
        else begin
          state <= 2'b10;
        end
        p <= a; q <= 0;
      end
      
      2'b10: begin // State 2
        if (a == 0) begin
          state <= 2'b00;
        end
        p <= 1; q <= 1;
      end
      
      default: begin
        state <= 2'b00;
        p <= 0; q <= 0;
      end
    endcase
  end
endmodule