module TopModule (
  input clk,
  input resetn,
  input in,
  output reg [3:0] out
);

reg [3:0] reg_data;

always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    reg_data <= 4'b0000;
  end else begin
    reg_data <= {reg_data[2:0], in};
  end
end

assign out = reg_data;

endmodule