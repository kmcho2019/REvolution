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
    reg_file <= 16'b0; // Synchronous reset
  end else begin
    // Utilize bitwise operations to update specific portions of the register based on byteena
    reg_file = (byteena[1]) ? {8'b0, d[15:8]} & {8'b1, 8'b0} | ({8'b0, reg_file[7:0]} & {8'b0, 8'b1});
    reg_file = (byteena[0]) ? {d[7:0], 8'b0} & {8'b0, 8'b1} | ({reg_file[15:8], 8'b0} & {8'b1, 8'b0}) : reg_file;
  end
end

assign q = reg_file;

endmodule