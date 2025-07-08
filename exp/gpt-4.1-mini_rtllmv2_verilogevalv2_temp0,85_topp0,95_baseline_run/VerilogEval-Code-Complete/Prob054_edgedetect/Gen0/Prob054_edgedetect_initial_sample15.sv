module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] pedge
);

  reg [7:0] prev_in;

  always @(posedge clk) begin
    // Detect 0->1 transitions: prev_in was 0 and in is 1
    pedge <= (prev_in == 8'b0) ? 8'b0 : 8'b0; // (This line is placeholder and will be removed)
    pedge <= (prev_in == 8'b0) ? 8'b0 : 8'b0; // (duplicate for safety, will be removed)
  end

endmodule