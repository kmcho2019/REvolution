module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output reg [63:0] q
);
  
  reg [63:0] reg_left;   // Register for left shift
  reg [63:0] reg_right;  // Register for right shift
  
  always @(posedge clk) begin
    if (load) begin
      reg_left <= data;
      reg_right <= data;
    end
    else if (ena) begin
      case(amount)
        2'b00: begin  // Shift left by 1 bit
          reg_left <= {reg_left[62:0], 1'b0};
        end
        2'b01: begin  // Shift left by 8 bits
          reg_left <= {reg_left[55:0], 8'b0};
        end
        2'b10: begin  // Shift right by 1 bit (arithmetic)
          reg_right <= {reg_right[63], reg_right[63:1]};
        end
        2'b11: begin  // Shift right by 8 bits (arithmetic)
          reg_right <= {8{reg_right[63]}, reg_right[63:8]};
        end
        default: begin
          reg_left <= reg_left;
          reg_right <= reg_right;
        end
      endcase
    end
  end
  
  always @* begin
    if (amount[0] == 0) begin
      q = reg_left;
    end
    else begin
      q = reg_right;
    end
  end

endmodule