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
    reg_file <= 16'b0; // Reset all flip-flops synchronously
  end else begin
    // Write to the flip-flops based on byteena directly
    if (byteena[0]) begin
      reg_file[7:0] <= d[7:0];
    end
    if (byteena[1]) begin
      reg_file[15:8] <= d[15:8];
    end
  end
end

assign q = (byteena[1]) ? ((byteena[0]) ? d : {8'd0, d[15:8]}) : ((byteena[0]) ? {d[7:0], 8'd0} : q);

endmodule