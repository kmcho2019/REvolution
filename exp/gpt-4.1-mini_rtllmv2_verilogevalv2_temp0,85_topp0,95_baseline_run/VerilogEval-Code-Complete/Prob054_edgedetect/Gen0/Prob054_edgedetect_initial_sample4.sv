module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] pedge
);

  reg [7:0] in_d;  // delayed input to hold previous cycle's value

  always @(posedge clk) begin
    // Detect 0-to-1 transition by checking previous input and current input
    pedge <= (~in_d) & in;  
    in_d <= in;  // update previous input
  end

endmodule