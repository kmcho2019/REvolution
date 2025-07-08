module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

  always @(*) begin
    // Default assignments
    Y0 = 1'b0;
    z  = 1'b0;

    // Output z depends only on current state y
    case (y)
      3'b011, 3'b100: z = 1'b1;
      default:       z = 1'b0;
    endcase

    // Next state bit 0 (Y0) depends on y and x
    case ({y, x})
      {3'b000, 1'b0}: Y0 = 1'b0; // next=000
      {3'b000, 1'b1}: Y0 = 1'b1; // next=001
      {3'b001, 1'b0}: Y0 = 1'b1; // next=001
      {3'b001, 1'b1}: Y0 = 1'b0; // next=100
      {3'b010, 1'b0}: Y0 = 1'b0; // next=010
      {3'b010, 1'b1}: Y0 = 1'b1; // next=001
      {3'b011, 1'b0}: Y0 = 1'b1; // next=001
      {3'b011, 1'b1}: Y0 = 1'b0; // next=010
      {3'b100, 1'b0}: Y0 = 1'b1; // next=011
      {3'b100, 1'b1}: Y0 = 1'b0; // next=100
      default:       Y0 = 1'b0; // default safe value
    endcase
  end

endmodule