module TopModule (
  input clk,
  input resetn,
  input [1:0] byteena,
  input [15:0] d,
  output reg [15:0] q
);

reg [7:0] reg_lower;
reg [7:0] reg_upper;

always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    reg_lower <= 8'b0;
    reg_upper <= 8'b0;
  end else begin
    // Update lower byte DFF
    if (byteena[0]) begin
      reg_lower <= d[7:0];
    end
      
    // Update upper byte DFF
    if (byteena[1]) begin
      reg_upper <= d[15:8];
    end
  end
end

assign q = {reg_upper, reg_lower};

endmodule