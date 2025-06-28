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
    // Write to individual flip-flops based on byteena signals
    if (byteena[0]) begin
      if (byteena[1]) begin
        reg_file <= d; // Write all bits of d to reg_file
      end else begin
        reg_file[7:0] <= d[7:0]; // Write lower byte of d to reg_file
      end
    end else if (byteena[1]) begin
      reg_file[15:8] <= d[15:8]; // Write upper byte of d to reg_file
    end
  end
end

assign q = reg_file;

endmodule