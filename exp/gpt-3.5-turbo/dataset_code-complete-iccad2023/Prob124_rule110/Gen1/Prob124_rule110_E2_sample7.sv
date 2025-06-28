module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  reg [511:0] next_q;
  
  // Combinatorial logic block for Rule 110
  always @(*)
  begin
    integer i;
    for (i = 0; i < 512; i = i + 1) begin
      int left = (i == 0) ? 0 : q[i-1];
      int right = (i == 511) ? 0 : q[i+1];
      
      case({left, q[i], right})
        3'b111: next_q[i] = 1'b0;
        3'b110: next_q[i] = 1'b1;
        3'b101: next_q[i] = 1'b1;
        3'b100: next_q[i] = 1'b0;
        3'b011: next_q[i] = 1'b1;
        3'b010: next_q[i] = 1'b1;
        3'b001: next_q[i] = 1'b1;
        3'b000: next_q[i] = 1'b0;
      endcase
    end
  end

  // Synchronous update of cell states on each positive clock edge
  always @(posedge clk)
  begin
    if (load)
      q <= data;
    else
      q <= next_q;
  end

endmodule