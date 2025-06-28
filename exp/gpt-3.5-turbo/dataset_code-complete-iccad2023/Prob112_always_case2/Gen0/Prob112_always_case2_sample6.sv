module PriorityEncoder(
  input [3:0] in,
  output reg [1:0] pos
);

  integer i;
  
  always @* begin
    pos = 2'b00;
    for(i = 0; i < 4; i = i + 1) begin
      if(in[i] == 1) begin
        pos = i;
        break; // Exit loop if a high bit is found
      end
    end
  end
  
endmodule