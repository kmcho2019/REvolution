module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);
  
  always @(posedge clk)
  begin
    if (load) begin
      q <= data;
    end
    else begin
      reg [511:0] next_q;
      
      // Apply Rule 110 to all cells, handling boundary conditions
      for (int i = 0; i < 512; i = i + 1) begin
        case(i)
          0: next_q[i] = (q[1] & q[0]) ? 1'b0 : ((~q[1] & q[0]) | (q[1] & ~q[0])) ? 1'b1 : ((~q[1] & ~q[0])) ? 1'b1 : 1'b0;
          511: next_q[i] = (q[510] & q[511]) ? 1'b0 : ((~q[510] & q[511]) | (q[510] & ~q[511])) ? 1'b1 : ((~q[510] & ~q[511])) ? 1'b1 : 1'b0;
          default: next_q[i] = (q[i-1] & q[i] & q[i+1]) ? 1'b0 : ((~q[i-1] & q[i] & q[i+1]) | (q[i-1] & ~q[i] & q[i+1]) | (q[i-1] & q[i] & ~q[i+1])) ? 1'b1 : 1'b0;
        endcase
      end
      
      q <= next_q;
    end
  end
  
endmodule