module TopModule (
  input clk,
  input resetn,
  input [1:0] byteena,
  input [15:0] d,
  output reg [15:0] q
);
  
  reg [15:0] register;

  always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
      register <= 16'h0; // Reset all flip-flops
    end else begin
      // Apply bitwise AND operation for upper byteena and mask with input data
      register[15:8] <= (byteena[1] & 2'b10) ? d[15:8] : register[15:8];
      // Apply bitwise AND operation for lower byteena and mask with input data
      register[7:0] <= (byteena[0] & 2'b01) ? d[7:0] : register[7:0];
    end
  end

  // Output
  always @*
    q = register;

endmodule