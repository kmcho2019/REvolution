module Rule110 (
  input left,
  input center,
  input right,
  output reg next_state
);
  
  always @(*)
    case({left, center, right})
      3'b111: next_state = 1'b0;
      3'b110: next_state = 1'b1;
      3'b101: next_state = 1'b1;
      3'b100: next_state = 1'b0;
      3'b011: next_state = 1'b1;
      3'b010: next_state = 1'b1;
      3'b001: next_state = 1'b1;
      3'b000: next_state = 1'b0;
    endcase
endmodule

module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);
  
  reg [511:0] next_q;
  
  always @*
    begin
      for (int i = 0; i < 512; i = i + 1)
        begin
          int left = (i == 0) ? 1'b0 : q[i-1];
          int right = (i == 511) ? 1'b0 : q[i+1];
          
          Rule110 rule110_inst (
            .left(left),
            .center(q[i]),
            .right(right),
            .next_state(next_q[i])
          );
        end
    end
  
  always @(posedge clk)
    begin
      if (load)
        q <= data;
      else
        q <= next_q;
    end

endmodule