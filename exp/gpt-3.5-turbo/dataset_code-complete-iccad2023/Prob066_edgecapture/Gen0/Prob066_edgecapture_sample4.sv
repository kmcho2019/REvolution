module TopModule (
  input clk,
  input reset,
  input [31:0] in,
  output reg [31:0] out
);
  
  reg [31:0] edge_detected;
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      edge_detected <= 32'b0;
      out <= 32'b0;
    end
    else begin
      for (int i=0; i<32; i=i+1) begin
        if (in[i] && !edge_detected[i]) begin // input is 1 and edge not detected yet
          edge_detected[i] <= 1'b1;
        end
        else if (!in[i]) begin // input is 0
          edge_detected[i] <= 1'b0;
          out[i] <= 1'b1;
        end
      end
    end
  end
  
endmodule