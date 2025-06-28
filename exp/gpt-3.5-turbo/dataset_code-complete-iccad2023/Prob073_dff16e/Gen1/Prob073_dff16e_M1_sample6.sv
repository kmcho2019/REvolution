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
    reg_file <= 16'b0; // Synchronous reset on positive clock edge
  end else begin
    // Write to the specific byte based on byteena inputs
    reg_file = (byteena[1]) ? {8'b0, d[15:8]} : reg_file; // Upper byte if byteena[1] is high
    reg_file = (byteena[0]) ? {d[7:0], 8'b0} : reg_file;   // Lower byte if byteena[0] is high
  end
end

assign q = reg_file;

endmodule