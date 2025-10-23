// Cell module
module Cell (
  input clk,
  input load,
  input center,
  input left,
  input right,
  output q
);

reg q_reg;

always @(posedge clk) begin
  if (load) begin
    q_reg <= center;
  end else begin
    q_reg <= left ^ right;
  end
end

assign q = q_reg;

endmodule

// TopModule
module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output [511:0] q
);

wire [511:0] lefts;
wire [511:0] rights;
wire [511:0] centers;

// Generate cells
Cell cells[511:0] (
  .clk(clk),
  .load(load),
  .center(data),
  .left(lefts),
  .right(rights),
  .q(q)
);

// Generate lefts and rights
assign lefts[0] = 1'b0;
assign rights[511] = 1'b0;
for (genvar i = 1; i < 511; i++) begin
  assign lefts[i] = data[i-1];
  assign rights[i] = data[i+1];
end

// Generate centers
assign centers = data;

endmodule