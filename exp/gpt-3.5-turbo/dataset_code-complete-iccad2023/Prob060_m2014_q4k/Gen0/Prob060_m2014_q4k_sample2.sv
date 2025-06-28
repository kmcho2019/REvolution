module TopModule (
  input clk,
  input resetn,
  input in,
  output reg [3:0] out
);

reg [3:0] reg_data;

always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    reg_data <= 4'b0;
  end
  else begin
    reg_data <= {in, reg_data[3:1]};
  end
end

assign out = reg_data[0];

endmodule