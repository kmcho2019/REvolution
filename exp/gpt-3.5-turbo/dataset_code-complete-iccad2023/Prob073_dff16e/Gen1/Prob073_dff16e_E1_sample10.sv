module TopModule (
  input clk,
  input resetn,
  input [1:0] byteena,
  input [15:0] d,
  output reg [15:0] q
);

reg [15:0] reg_file;

always @(posedge clk) begin
  if (!resetn) begin
    reg_file <= 16'b0; // Reset all flip-flops
  end else begin
    // Mask the data input based on byteena and update the register using bitwise operations
    reg_file = ((~{byteena[1], byteena[0]}) & d) | ({byteena[1], byteena[0]} & reg_file);
  end
end

assign q = reg_file;

endmodule