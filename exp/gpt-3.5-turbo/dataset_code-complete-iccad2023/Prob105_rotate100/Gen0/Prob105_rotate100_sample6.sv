module Rotator (
  input clk,
  input load,
  input [1:0] ena,
  input [99:0] data,
  output reg [99:0] q
);

  reg [99:0] left_rotator, right_rotator;
  
  always @ (posedge clk) begin
    // Load logic
    if (load) begin
      left_rotator <= data;
      right_rotator <= data;
    end
    // Rotate left by one bit
    else if (ena == 2'b10) begin
      left_rotator <= {left_rotator[98:0], left_rotator[99]};
      right_rotator <= {right_rotator[0], right_rotator[99:1]};
    end
    // Rotate right by one bit
    else if (ena == 2'b01) begin
      left_rotator <= {left_rotator[1:99], left_rotator[0]};
      right_rotator <= {right_rotator[99], right_rotator[0:98]};
    end
  end

  always @* begin
    // Select output based on ena
    case (ena)
      2'b01: q = right_rotator;
      2'b10: q = left_rotator;
      default: q = data;
    endcase
  end

endmodule