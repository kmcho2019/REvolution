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
          p <= 0; q <= 0;
        end
      end
      
      2'b01: begin // State 1
        if (a == 1) begin
          state <= 2'b10;
          p <= 1; q <= 0;
        end
        else begin
          state <= 2'b00;
          p <= 0; q <= 0;
        end
      end
      
      2'b10: begin // State 2
        if (a == 0) begin
          state <= 2'b00;
          p <= 0; q <= 1;
        end
      end
    endcase
  end
endmodule