module TopModule (
  input clk,
  input [7:0] d,
  input reset,
  output reg [7:0] q
);

  reg [7:0] q_temp;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      q_temp <= 8'b0; // Reset all flip-flops to 0
    end else begin
      for (int i=0; i<8; i=i+1) begin
        if (i == 0) begin
          q_temp[i] <= (d[i]) ? 1'b1 : 1'b0;
        end else begin
          q_temp[i] <= (d[i] & ~reset) ? 1'b1 : q_temp[i-1];
        end
      end
    end
  end

  assign q = q_temp;
  
endmodule