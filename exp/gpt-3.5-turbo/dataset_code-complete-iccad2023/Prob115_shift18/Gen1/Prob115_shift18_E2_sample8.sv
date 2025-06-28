module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output reg [63:0] q
);

  reg [64:0] shifted_data; // 64-bit buffer to handle shifts effectively

  always @(posedge clk) begin
    if (load) begin
      shifted_data <= {data, 8'd0}; // Load data into buffer
    end else if (ena) begin
      case(amount)
        2'b00: shifted_data <= {shifted_data[62:0], shifted_data[63]}; // Shift left by 1 bit
        2'b01: shifted_data <= {shifted_data[55:0], shifted_data[63:56]}; // Shift left by 8 bits

        2'b10: begin // Shift right by 1 bit (arithmetic right shift)
          shifted_data[64] <= shifted_data[64]; // MSB is sign bit for arithmetic right shift
          shifted_data <= {shifted_data[64], shifted_data[63:1]};
        end

        2'b11: begin // Shift right by 8 bits (arithmetic right shift)
          shifted_data[64] <= shifted_data[64]; // MSB is sign bit for arithmetic right shift
          shifted_data <= {shifted_data[56:0], {7{shifted_data[64]}}}; // Sign extend by repeating sign bit
        end

        default: shifted_data <= shifted_data; // No shift
      endcase
    end
  end

  // Output assignment - truncated to 64 bits
  assign q = shifted_data[63:0];

endmodule