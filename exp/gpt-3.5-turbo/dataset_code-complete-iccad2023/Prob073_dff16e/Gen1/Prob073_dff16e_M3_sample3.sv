module TopModule (
  input clk,
  input resetn,
  input [1:0] byteena,
  input [15:0] d,
  output reg [15:0] q
);

reg [15:0] reg_file;

always @(posedge clk) begin
  if (~resetn) begin
    reg_file <= 16'b0; // Reset all flip-flops on active-low synchronous reset
  end else begin
    reg_file <= (byteena[1]) ? {reg_file[15:8], d[15:8]} : reg_file;
    reg_file <= (byteena[0]) ? {reg_file[7:0], d[7:0]} : reg_file;
  end
end

assign q = reg_file;

endmodule