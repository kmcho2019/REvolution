module TopModule (
  input clk,
  input load,
  input [1:0] ena,
  input [99:0] data,
  output reg [99:0] q
);

  reg [99:0] shift_reg;

  always @(posedge clk) begin
    if (load) begin
      shift_reg <= data;
    end else begin
      case (ena)
        2'b01: shift_reg <= {shift_reg[0], shift_reg[99:1]}; // Right shift
        2'b10: shift_reg <= {shift_reg[1:99], shift_reg[0]}; // Left shift
        default: shift_reg <= shift_reg; // No rotation
      endcase
    end
  end

  always @* begin
    q = shift_reg;
  end

endmodule