module TopModule (
  input clk,
  input resetn,
  input [1:0] byteena,
  input [15:0] d,
  output reg [15:0] q
);

reg [15:0] reg_file;

always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    reg_file <= 16'b0; // Reset all flip-flops
  end else begin
    // Use a loop to handle all 16 flip-flops
    for (int i = 0; i < 16; i = i + 1) begin
      if (byteena[0] && i < 8) begin
        reg_file[i] <= d[i];
      end
      if (byteena[1] && i >= 8) begin
        reg_file[i] <= d[i];
      end
    end
  end
end

assign q = reg_file;

endmodule