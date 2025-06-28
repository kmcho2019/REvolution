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
    reg_file <= 16'b0; // Reset all flip-flops on positive clock edge
  end else begin
    // Write to the specific bytes based on byte enable signals
    case(byteena)
      2'b01: reg_file[7:0] <= d[7:0]; // Write to lower byte
      2'b10: reg_file[15:8] <= d[15:8]; // Write to upper byte
      2'b11: reg_file <= d; // Write to all bytes
      default: // No write operation
    endcase
  end
end

assign q = reg_file;

endmodule