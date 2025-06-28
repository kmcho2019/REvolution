module TopModule (
  input clk,
  input resetn,
  input [1:0] byteena,
  input [15:0] d,
  output reg [15:0] q
);

reg [7:0] reg_file_lower;
reg [7:0] reg_file_upper;

always @(posedge clk) begin
  if (!resetn) begin
    reg_file_lower <= 8'b0; // Reset lower byte D flip-flops
    reg_file_upper <= 8'b0; // Reset upper byte D flip-flops
  end else begin
    // Write to the individual flip-flops based on byteena
    if (byteena[0]) begin
      reg_file_lower <= d[7:0];
    end
    if (byteena[1]) begin
      reg_file_upper <= d[15:8];
    end
  end
end

assign q = {reg_file_upper, reg_file_lower};

endmodule