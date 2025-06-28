module TopModule (
  input clk,
  input load,
  input [1:0] ena,
  input [99:0] data,
  output reg [99:0] q
);

  // Internal signals
  reg [99:0] shift_reg;

  always @(posedge clk) begin
    if (load) begin
      // Load data into shift register
      shift_reg <= data;
    end else begin
      // Rotate based on ena signal
      case (ena)
        2'b01: begin
          // Rotate right by one bit
          shift_reg <= {shift_reg[0], shift_reg[99:1]};
        end
        2'b10: begin
          // Rotate left by one bit
          shift_reg <= {shift_reg[1:99], shift_reg[0]};
        end
        default: begin
          // No rotation
          shift_reg <= shift_reg;
        end
      endcase
    end
  end
  
  // Output
  assign q = shift_reg;

endmodule