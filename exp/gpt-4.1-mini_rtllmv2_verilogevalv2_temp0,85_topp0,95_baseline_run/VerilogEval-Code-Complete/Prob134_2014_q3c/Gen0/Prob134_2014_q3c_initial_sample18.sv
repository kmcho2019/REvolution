module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

always @(*) begin
  case ({y, x})
    // y=000 (0)
    {3'b000, 1'b0}: begin Y0 = 1'b0; z = 1'b0; end // Next Y=000 -> Y0=0, z=0
    {3'b000, 1'b1}: begin Y0 = 1'b1; z = 1'b0; end // Next Y=001 -> Y0=1, z=0

    // y=001 (1)
    {3'b001, 1'b0}: begin Y0 = 1'b1; z = 1'b0; end // Next Y=001 -> Y0=1, z=0
    {3'b001, 1'b1}: begin Y0 = 1'b0; z = 1'b0; end // Next Y=100 -> Y0=0, z=0

    // y=010 (2)
    {3'b010, 1'b0}: begin Y0 = 1'b0; z = 1'b0; end // Next Y=010 -> Y0=0, z=0
    {3'b010, 1'b1}: begin Y0 = 1'b1; z = 1'b0; end // Next Y=001 -> Y0=1, z=0

    // y=011 (3)
    {3'b011, 1'b0}: begin Y0 = 1'b1; z = 1'b1; end // Next Y=001 -> Y0=1, z=1
    {3'b011, 1'b1}: begin Y0 = 1'b0; z = 1'b1; end // Next Y=010 -> Y0=0, z=1

    // y=100 (4)
    {3'b100, 1'b0}: begin Y0 = 1'b1; z = 1'b1; end // Next Y=011 -> Y0=1, z=1
    {3'b100, 1'b1}: begin Y0 = 1'b0; z = 1'b1; end // Next Y=100 -> Y0=0, z=1

    default: begin
      Y0 = 1'b0;
      z = 1'b0;
    end
  endcase
end

endmodule